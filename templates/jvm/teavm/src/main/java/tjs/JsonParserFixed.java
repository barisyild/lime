package tjs;

import java.io.IOException;
import java.io.Reader;

public class JsonParserFixed {
    private JsonConsumer consumer;
    private int lastChar;
    private int lineNumber;
    private int columnNumber;
    private boolean cr;

    public JsonParserFixed(JsonConsumer consumer) {
        this.consumer = consumer;
    }

    public void parse(String input) throws IOException {
        src = input;
        srcPos = 0;
        parse((Reader) null);
    }

    private String src;
    private int srcPos;
    private final StringBuilder sharedSb = new StringBuilder(64);

    private int readSrc() {
        return srcPos < src.length() ? src.charAt(srcPos++) : -1;
    }

    public void parse(Reader reader) throws IOException {
        lineNumber = 0;
        columnNumber = 0;
        lastChar = readSrc();
        skipWhitespaces(reader);
        if (lastChar == -1) {
            error("Unexpected end of file");
        }
        parseValue(reader);
        skipWhitespaces(reader);
        if (lastChar != -1) {
            error("Unexpected characters after end of JSON string");
        }
    }

    private void parseValue(Reader reader) throws IOException {
        switch (lastChar) {
            case '{':
                parseObject(reader);
                break;
            case '[':
                parseArray(reader);
                break;
            case '\"':
                parseString(reader);
                break;
            case '-':
            case '0':
            case '1':
            case '2':
            case '3':
            case '4':
            case '5':
            case '6':
            case '7':
            case '8':
            case '9':
                parseNumber(reader);
                break;
            case 'n':
                parseNull(reader);
                break;
            case 't':
                parseTrue(reader);
                break;
            case 'f':
                parseFalse(reader);
                break;
            default:
                error("Unexpected character");
                break;
        }
    }

    private void parseObject(Reader reader) throws IOException {

        consumer.enterObject(errorReporter);
        nextChar(reader);
        skipWhitespaces(reader);
        if (lastChar == '}') {
            nextChar(reader);
            consumer.exitObject(errorReporter);
            return;
        }

        parseProperty(reader);
        while (lastChar != '}') {
            if (lastChar != ',') {
                error("Either property delimiter (',') or end of object ('}') expected");
            }
            nextChar(reader);
            skipWhitespaces(reader);
            parseProperty(reader);
        }
        nextChar(reader);
        consumer.exitObject(errorReporter);
    }

    private void parseProperty(Reader reader) throws IOException {
        skipWhitespaces(reader);
        if (lastChar != '"') {
            error("Object key (string literal) expected");
        }
        String name = parseStringLiteral(reader);
        consumer.enterProperty(errorReporter, name);
        skipWhitespaces(reader);
        if (lastChar != ':') {
            error("':' character expected after property name");
        }
        nextChar(reader);
        skipWhitespaces(reader);
        parseValue(reader);
        consumer.exitProperty(errorReporter, name);
        skipWhitespaces(reader);
    }

    private void parseArray(Reader reader) throws IOException {
        consumer.enterArray(errorReporter);
        nextChar(reader);
        skipWhitespaces(reader);

        if (lastChar == ']') {
            nextChar(reader);
            consumer.exitArray(errorReporter);
            return;
        }

        parseValue(reader);
        skipWhitespaces(reader);
        while (lastChar != ']') {
            if (lastChar != ',') {
                error("Either array item delimiter (',') or end of array (']') expected");
            }
            nextChar(reader);
            skipWhitespaces(reader);
            parseValue(reader);
            skipWhitespaces(reader);
        }
        nextChar(reader);

        consumer.exitArray(errorReporter);
    }

    private void parseString(Reader reader) throws IOException {
        consumer.stringValue(errorReporter, parseStringLiteral(reader));
    }

    private String parseStringLiteral(Reader reader) throws IOException {
        nextChar(reader);
        int startIdx = srcPos - 1;
        int len = src.length();
        int p = startIdx;
        int segStart = startIdx;
        StringBuilder sb = null;
        while (true) {
            if (p >= len) {
                srcPos = len;
                lastChar = -1;
                error("Unexpected end of input inside string literal");
            }
            char c = src.charAt(p);
            if (c == '\"') {
                String tail = src.substring(segStart, p);
                columnNumber += (p - startIdx) + 1;
                srcPos = p + 1;
                lastChar = readSrc();
                if (sb == null) {
                    return tail;
                }
                sb.append(tail);
                return sb.toString();
            }
            if (c < ' ') {
                srcPos = p + 1;
                lastChar = c;
                error("Unexpected control character inside string literal");
            }
            if (c == '\\') {
                if (sb == null) {
                    sb = sharedSb;
                    sb.setLength(0);
                }
                sb.append(src, segStart, p);
                p++;
                if (p >= len) {
                    srcPos = len;
                    lastChar = -1;
                    error("Unexpected end of input inside string literal");
                }
                char e = src.charAt(p);
                switch (e) {
                    case '\"':
                    case '\\':
                    case '/':
                        sb.append(e);
                        p++;
                        break;
                    case 'b':
                        sb.append('\b');
                        p++;
                        break;
                    case 'f':
                        sb.append('\f');
                        p++;
                        break;
                    case 'n':
                        sb.append('\n');
                        p++;
                        break;
                    case 'r':
                        sb.append('\r');
                        p++;
                        break;
                    case 't':
                        sb.append('\t');
                        p++;
                        break;
                    case 'u': {
                        if (p + 4 >= len) {
                            srcPos = len;
                            lastChar = -1;
                            error("Unexpected end of input inside string literal");
                        }
                        int code = (hexVal(src.charAt(p + 1)) << 12) | (hexVal(src.charAt(p + 2)) << 8)
                                | (hexVal(src.charAt(p + 3)) << 4) | hexVal(src.charAt(p + 4));
                        sb.append((char) code);
                        p += 5;
                        break;
                    }
                    default:
                        srcPos = p + 1;
                        lastChar = e;
                        error("Wrong escape sequence");
                }
                segStart = p;
                continue;
            }
            p++;
        }
    }

    private int hexVal(char c) {
        if (c >= '0' && c <= '9') {
            return c - '0';
        }
        if (c >= 'a' && c <= 'f') {
            return c - 'a' + 10;
        }
        if (c >= 'A' && c <= 'F') {
            return c - 'A' + 10;
        }
        error("Wrong escape sequence");
        return 0;
    }


    private int getHexDigit(Reader reader) throws IOException {
        int value;
        if (lastChar >= '0' && lastChar <= '9') {
            value = lastChar - '0';
        } else if (lastChar >= 'A' && lastChar <= 'F') {
            value = lastChar - 'A' + 10;
        } else if (lastChar >= 'a' && lastChar <= 'f') {
            value = lastChar - 'a' + 10;
        } else {
            error("Wrong escape sequence");
            value = 0;
        }
        nextChar(reader);
        return value;
    }

    private void parseNumber(Reader reader) throws IOException {
        boolean isFloatingPoint = false;
        StringBuilder sb = new StringBuilder();
        if (lastChar == '-') {
            acceptChar(sb, reader);
        }
        if (lastChar == '0') {
            acceptChar(sb, reader);
        } else {
            if (!isDigit(lastChar)) {
                if (lastChar == 'e' || lastChar == 'E' || lastChar == '.') {
                    error("Wrong number, at least one digit expected in integer part");
                } else {
                    error("Wrong number, digits must follow '-' sign");
                }
            }
            acceptChar(sb, reader);
            while (isDigit(lastChar)) {
                acceptChar(sb, reader);
            }
        }

        if (lastChar == '.') {
            isFloatingPoint = true;
            acceptChar(sb, reader);
            if (!isDigit(lastChar)) {
                error("Wrong number, at least one digit must be in fraction part");
            }
            acceptChar(sb, reader);
            while (isDigit(lastChar)) {
                acceptChar(sb, reader);
            }
        }

        if (lastChar == 'e' || lastChar == 'E') {
            isFloatingPoint = true;
            acceptChar(sb, reader);
            if (lastChar == '+' || lastChar == '-') {
                acceptChar(sb, reader);
            }
            if (!isDigit(lastChar)) {
                error("Wrong number, at least one digit must be in exponent");
            }
            acceptChar(sb, reader);
            while (isDigit(lastChar)) {
                acceptChar(sb, reader);
            }
        }

        expectEndOfToken("Wrong number");

        if (isFloatingPoint) {
            tryParseDouble(sb);
        } else {
            long value;
            try {
                value = Long.parseLong(sb.toString());
            } catch (NumberFormatException e) {
                tryParseDouble(sb);
                return;
            }
            consumer.intValue(errorReporter, value);
        }
    }

    private void tryParseDouble(StringBuilder sb) {
        double value;
        try {
            value = Double.parseDouble(sb.toString());
        } catch (NumberFormatException e) {
            error("Wrong number");
            value = 0;
        }
        consumer.floatValue(errorReporter, value);
    }

    private void acceptChar(StringBuilder sb, Reader reader) throws IOException {
        sb.append((char) lastChar);
        nextChar(reader);
    }

    private void parseNull(Reader reader) throws IOException {
        expectIdentifier(reader, "null");
        consumer.nullValue(errorReporter);
    }

    private void parseTrue(Reader reader) throws IOException {
        expectIdentifier(reader, "true");
        consumer.booleanValue(errorReporter, true);
    }

    private void parseFalse(Reader reader) throws IOException {
        expectIdentifier(reader, "false");
        consumer.booleanValue(errorReporter, false);
    }

    private void expectIdentifier(Reader reader, String identifier) throws IOException {
        for (int i = 0; i < identifier.length(); ++i) {
            if (lastChar != identifier.charAt(i)) {
                error("Unexpected identifier");
            }
            nextChar(reader);
        }
        expectEndOfToken("Wrong identifier");
    }

    private void expectEndOfToken(String errorMessage) {
        switch (lastChar) {
            case '}':
            case '{':
            case '[':
            case ']':
            case ',':
            case ':':
                break;
            default:
                if (!isWhitespace(lastChar)) {
                    error(errorMessage);
                }
                break;
        }
    }

    private void skipWhitespaces(Reader reader) throws IOException {
        while (isWhitespace(lastChar)) {
            nextChar(reader);
        }
    }

    private void nextChar(Reader reader) throws IOException {
        boolean wasCr = cr;
        if (cr) {
            lineNumber++;
            columnNumber = 0;
            cr = false;
        }
        switch (lastChar) {
            case '\r':
                cr = true;
                break;
            case '\n':
                if (!wasCr) {
                    lineNumber++;
                    columnNumber = 0;
                }
                break;
            default:
                columnNumber++;
                break;
        }
        lastChar = readSrc();
    }

    void error(String error) {
        throw new JsonSyntaxException(lineNumber, columnNumber, error);
    }

    private JsonErrorReporter errorReporter = new JsonErrorReporter() {
        @Override
        public void error(String message) {
            JsonParserFixed.this.error(message);
        }
    };

    private static boolean isWhitespace(int c) {
        switch (c) {
            case ' ':
            case '\t':
            case '\n':
            case '\r':
                return true;
            default:
                return false;
        }
    }

    private static boolean isDigit(int c) {
        return c >= '0' && c <= '9';
    }
}