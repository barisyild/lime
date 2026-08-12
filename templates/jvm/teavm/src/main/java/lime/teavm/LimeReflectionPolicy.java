package lime.teavm;

import org.teavm.extension.ExtensionEnvironment;
import org.teavm.extension.introspect.IntrospectClass;
import org.teavm.extension.introspect.IntrospectField;
import org.teavm.extension.introspect.IntrospectMember;
import org.teavm.extension.introspect.IntrospectMethod;
import org.teavm.extension.introspect.IntrospectParameter;
import org.teavm.extension.spi.reflection.ReflectionPolicy;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

public class LimeReflectionPolicy implements ReflectionPolicy {
    private static final String ENTRY_CLASS = "haxe.root.ApplicationMain";

    private static final String[] EVENT_INFO_CLASSES = {
        "lime._internal.backend.native.ApplicationEventInfo",
        "lime._internal.backend.native.ClipboardEventInfo",
        "lime._internal.backend.native.DropEventInfo",
        "lime._internal.backend.native.GamepadEventInfo",
        "lime._internal.backend.native.JoystickEventInfo",
        "lime._internal.backend.native.KeyEventInfo",
        "lime._internal.backend.native.MouseEventInfo",
        "lime._internal.backend.native.OrientationEventInfo",
        "lime._internal.backend.native.RenderEventInfo",
        "lime._internal.backend.native.SensorEventInfo",
        "lime._internal.backend.native.TextEventInfo",
        "lime._internal.backend.native.TouchEventInfo",
        "lime._internal.backend.native.WindowEventInfo",
    };

    private static final String[] HAXE_CORE_CLASSES = {
        "haxe.ds.StringMap",
        "haxe.ds.IntMap",
        "haxe.ds.ObjectMap",
        "haxe.ds.EnumValueMap",
        "haxe.ds.List",
        "haxe.root.Array",
    };

    private static final Set<String> CLASSES = load();

    static Set<String> classes() {
        return CLASSES;
    }

    private static Set<String> load() {
        Set<String> classes = new HashSet<>();
        Collections.addAll(classes, EVENT_INFO_CLASSES);
        Collections.addAll(classes, HAXE_CORE_CLASSES);
        String path = System.getProperty("lime.teavm.reflectList");
        if (path != null && !path.isEmpty()) {
            try (BufferedReader reader = new BufferedReader(new FileReader(path))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    line = line.trim();
                    if (!line.isEmpty() && !line.equals(ENTRY_CLASS)) {
                        classes.add(line);
                    }
                }
            } catch (IOException e) {
                System.err.println("[lime-teavm] could not read reflect list '" + path + "': " + e);
            }
        } else {
            System.err.println("[lime-teavm] no lime.teavm.reflectList property — registering NO reflection");
        }
        System.err.println("[lime-teavm] LimeReflectionPolicy: " + classes.size() + " reflectable classes");
        return classes;
    }

    private final Map<String, Boolean> jsoCache = new HashMap<>();
    private IntrospectClass<?> jsObject;

    @Override
    public void initialize(ExtensionEnvironment env) {
        jsObject = env.findClass("org.teavm.jso.JSObject");
    }

    @Override
    public Collection<IntrospectMember> classAccessibleMembers(IntrospectClass<?> cls) {
        if (!registered(cls)) {
            return Collections.emptyList();
        }
        List<IntrospectMember> result = new ArrayList<>();
        for (IntrospectField field : cls.declaredFields()) {
            if (!isJSOType(field.type())) {
                result.add(field);
            }
        }
        for (IntrospectMethod method : cls.declaredMethods()) {
            if (!methodHasJSO(method)) {
                result.add(method);
            }
        }
        return result;
    }

    @Override
    public boolean isClassFoundByName(IntrospectClass<?> cls) {
        return registered(cls);
    }

    private boolean registered(IntrospectClass<?> cls) {
        return cls != null && CLASSES.contains(cls.name());
    }

    private boolean isJSOType(IntrospectClass<?> type) {
        while (type.isArray()) {
            type = type.componentType();
        }
        if (type.isPrimitive()) {
            return false;
        }
        String name = type.name();
        Boolean known = jsoCache.get(name);
        if (known != null) {
            return known;
        }
        boolean result = name.startsWith("org.teavm.jso.")
            || jsObject != null && jsObject.isAssignableFrom(type);
        jsoCache.put(name, result);
        return result;
    }

    private boolean methodHasJSO(IntrospectMethod method) {
        if (isJSOType(method.returnType())) {
            return true;
        }
        for (IntrospectParameter parameter : method.parameters()) {
            if (isJSOType(parameter.type())) {
                return true;
            }
        }
        return false;
    }
}
