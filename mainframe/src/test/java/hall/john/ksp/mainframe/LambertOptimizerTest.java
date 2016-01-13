package hall.john.ksp.mainframe;

import org.apache.commons.math3.geometry.euclidean.threed.Vector3D;
import org.junit.Test;

import hall.john.ksp.mainframe.orbit.OrbitAtTime;

public class LambertOptimizerTest {

	@Test
	public void test() {
		Body b = new Body("Earth", 3.986004418E14);
		double mu = b.getMu();

		OrbitAtTime oat0 = new OrbitAtTime(b, new Vector3D(280845.599191302, -5887127.19186784, -3177868.58724645),
		                                      new Vector3D(7690.8927747241, 347.4010718063, 187.5151928961));
		OrbitAtTime tgtOat0 = new OrbitAtTime(b, new Vector3D(-355482138.167304, 80409146.2590527, 43409396.101458),
		                                         new Vector3D(-235.5335940609, -914.1890350466, -493.5308454351));

		double tMin = 0;
		double tMax = 6000;
		double tStep = 60;
		double dtMin = 2 * 24 * 60 * 60;
		double dtMax = 8 * 24 * 60 * 60;
		double dtStep = 1954;

		LambertOptimizer lo = new LambertOptimizer(mu, oat0, tgtOat0, tMin, tMax, tStep, dtMin, dtMax, dtStep);
		lo.execute();

		Vector3D dv1 = lo.getDV1();
		Vector3D dv2 = lo.getDV2();
		double t = lo.getT();
		double dt = lo.getDT();

		TestUtils.assertVectorRelativelyEquals(-2336.2055666333, 1777.9481837768, 943.6883666524, dv1, 1e-9);
		TestUtils.assertVectorRelativelyEquals(695.681151565, -465.8924054596, -251.8111713676, dv2, 1e-9);
		TestUtils.assertRelativelyEquals(2040, t, 1e-9);
		TestUtils.assertRelativelyEquals(368200, dt, 1e-9);
	}
}
