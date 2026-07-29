package lime.teavm;

import org.teavm.classlib.ReflectionContext;
import org.teavm.classlib.ReflectionSupplier;
import org.teavm.model.ClassReader;
import org.teavm.model.ClassReaderSource;
import org.teavm.model.FieldReader;
import org.teavm.model.MethodDescriptor;
import org.teavm.model.MethodReader;
import org.teavm.model.ValueType;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

public class LimeReflectionSupplier implements ReflectionSupplier {
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
        System.err.println("[lime-teavm] LimeReflectionSupplier: " + classes.size() + " reflectable classes");
        return classes;
    }

    private boolean registered(String className) {
        return className != null && CLASSES.contains(className);
    }

    @Override
    public Collection<MethodDescriptor> getAccessibleMethods(ReflectionContext context, String className) {
        if (!registered(className)) {
            return Collections.emptyList();
        }
        ClassReader cls = context.getClassSource().get(className);
        if (cls == null) {
            return Collections.emptyList();
        }
        List<MethodDescriptor> result = new ArrayList<>();
        for (MethodReader method : cls.getMethods()) {
            if (methodHasJSO(context.getClassSource(), method.getDescriptor())) {
                continue;
            }
            result.add(method.getDescriptor());
        }
        return result;
    }

    @Override
    public Collection<String> getAccessibleFields(ReflectionContext context, String className) {
        if (!registered(className)) {
            return Collections.emptyList();
        }
        ClassReader cls = context.getClassSource().get(className);
        if (cls == null) {
            return Collections.emptyList();
        }
        List<String> result = new ArrayList<>();
        for (FieldReader field : cls.getFields()) {
            if (isJSOType(context.getClassSource(), field.getType())) {
                continue;
            }
            result.add(field.getName());
        }
        return result;
    }

    private static boolean isJSOType(ClassReaderSource source, ValueType type) {
        while (type instanceof ValueType.Array) {
            type = ((ValueType.Array) type).getItemType();
        }
        if (!(type instanceof ValueType.Object)) {
            return false;
        }
        String className = ((ValueType.Object) type).getClassName();
        if (className.equals("org.teavm.jso.JSObject") || className.startsWith("org.teavm.jso.")) {
            return true;
        }
        Boolean isJSO = source.isSuperType("org.teavm.jso.JSObject", className).orElse(false);
        return isJSO != null && isJSO;
    }

    private static boolean methodHasJSO(ClassReaderSource source, MethodDescriptor descriptor) {
        if (isJSOType(source, descriptor.getResultType())) {
            return true;
        }
        for (ValueType param : descriptor.getParameterTypes()) {
            if (isJSOType(source, param)) {
                return true;
            }
        }
        return false;
    }

    private Set<String> existing;

    private Set<String> existing(ReflectionContext context) {
        if (existing == null) {
            Set<String> found = new HashSet<>();
            int dropped = 0;
            for (String name : CLASSES) {
                if (context.getClassSource().get(name) != null) found.add(name);
                else dropped++;
            }
            if (dropped > 0) {
                System.err.println("[lime-teavm] LimeReflectionSupplier: dropped " + dropped
                    + " reflect-list names with no class on the TeaVM classpath");
            }
            existing = found;
        }
        return existing;
    }

    public Collection<String> getClassesFoundByName(ReflectionContext context) {
        return new ArrayList<>(existing(context));
    }

    @Override
    public boolean isClassFoundByName(ReflectionContext context, String className) {
        return registered(className) && existing(context).contains(className);
    }
}