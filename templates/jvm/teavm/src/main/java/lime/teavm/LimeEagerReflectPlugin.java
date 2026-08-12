package lime.teavm;

import org.teavm.dependency.AbstractDependencyListener;
import org.teavm.dependency.DependencyAgent;
import org.teavm.model.MethodReference;
import org.teavm.model.ValueType;
import org.teavm.vm.spi.TeaVMHost;
import org.teavm.vm.spi.TeaVMPlugin;

public class LimeEagerReflectPlugin implements TeaVMPlugin {
    @Override
    public void install(TeaVMHost host) {
        host.add(new AbstractDependencyListener() {
            private boolean linkedAll;

            @Override
            public void classReached(DependencyAgent agent, String className) {
                if (linkedAll) {
                    return;
                }
                linkedAll = true;
                linkAll(agent);
            }

            private void linkAll(DependencyAgent agent) {
                org.teavm.dependency.MethodDependency getName = agent.linkMethod(new MethodReference(Class.class, "getName", String.class));
                getName.getVariable(0).propagate(agent.getType(ValueType.object("java.lang.Class")));
                int linked = 0;
                int dropped = 0;
                for (String name : LimeReflectionPolicy.classes()) {
                    if (agent.getClassSource().get(name) != null) {
                        agent.linkClass(name);
                        getName.getVariable(0).getClassValueNode().propagate(agent.getType(ValueType.object(name)));
                        linked++;
                    } else {
                        dropped++;
                    }
                }
                getName.use();
                System.err.println("[lime-teavm] LimeEagerReflectPlugin: eagerly linked " + linked + " reflect-list classes");
                if (dropped > 0) {
                    System.err.println("[lime-teavm] LimeEagerReflectPlugin: dropped " + dropped
                        + " reflect-list names with no class on the TeaVM classpath");
                }
            }
        });
    }
}