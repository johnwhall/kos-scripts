package hall.john.ksp.mainframe;

import org.apache.commons.math3.geometry.euclidean.threed.Vector3D;
import org.junit.Assert;
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

		LambertOptimizer lo = new LambertOptimizer(mu, oat0, tgtOat0, tMin, tMax, tStep, dtMin, dtMax, dtStep, true,
				false);
		lo.execute();

		Vector3D dv1 = lo.getDV1();
		Vector3D dv2 = lo.getDV2();
		double t = lo.getT();
		double dt = lo.getDT();

		Assert.assertEquals(26866, lo.getCount());
		TestUtils.assertVectorRelativelyEquals(-2336.2055666333, 1777.9481837768, 943.6883666524, dv1, 1e-9);
		TestUtils.assertVectorRelativelyEquals(695.681151565, -465.8924054596, -251.8111713676, dv2, 1e-9);
		TestUtils.assertRelativelyEquals(2040, t, 1e-9);
		TestUtils.assertRelativelyEquals(368200, dt, 1e-9);
	}

	@Test
	public void test2() {
		for (int i = 0; i < 100; i++) {
			Body b = new Body("Earth", 3.986004418E14);
			double mu = b.getMu();

			OrbitAtTime oat0 = new OrbitAtTime(b, new Vector3D(5507077.05790552, -3584709.45138777, -6.256561471),
					new Vector3D(4248.8908942288, 6527.4400999656, 0.0113926318));
			OrbitAtTime tgtOat0 = new OrbitAtTime(b, new Vector3D(5912477.98807351, -3299855.30599648, -5.7593520033),
					new Vector3D(3739.2505332585, 6699.759359006, 0.0116932746));

			double tMin = 0;
			double tMax = 120538.278779887 * 1;
			double tStep = 1205.38278779887 / 100;
			double dtMin = 5172.92991419679 / 1;
			double dtMax = 5672.92991419679 * 1;
			double dtStep = 1;

			LambertOptimizer lo = new LambertOptimizer(mu, oat0, tgtOat0, tMin, tMax, tStep, dtMin, dtMax, dtStep, true,
					false);
			lo.execute();

			Vector3D dv1 = lo.getDV1();
			Vector3D dv2 = lo.getDV2();
			double t = lo.getT();
			double dt = lo.getDT();
			double dv = dv1.getNorm();

			Assert.assertEquals(5010501, lo.getCount());
			System.out.println(dv1 + " " + dv2 + " " + dv + " " + t + " " + dt);
			TestUtils.assertVectorRelativelyEquals(79.2032486357, -259.367961919, -0.00045215772593656077, dv1, 1e-9);
			TestUtils.assertVectorRelativelyEquals(-164.2847412747, 424.4642747304, 0.0007407846716598644, dv2, 1e-9);
			TestUtils.assertRelativelyEquals(55459.662066626006, t, 1e-9);
			TestUtils.assertRelativelyEquals(5172.92991419679, dt, 1e-9);
		}
	}

	@Test
	public void test3() {
		for (int i = 0; i < 100; i++) {
			Body b = new Body("Earth", 3.986004418E14);
			double mu = b.getMu();

			OrbitAtTime oat0 = new OrbitAtTime(b, new Vector3D(6217625.33521472, -719829.378348098, 1918106.38746952),
					new Vector3D(1657.6952993448, 7081.1412827167, -2921.2092857134));
			OrbitAtTime tgtOat0 = new OrbitAtTime(b,
					new Vector3D(5680511.51363976, -2590290.72677682, 2614657.68661689),
					new Vector3D(3839.9493325346, 6297.5479758191, -2114.4648415501));

			double tMin = 190.0;
			double tMax = 149488.979965825;
			double tStep = 14.9298979965825;
			double dtMin = 0;
			double dtMax = 5539.93622202688;
			double dtStep = 11.0798724440538;

			LambertOptimizer lo = new LambertOptimizer(mu, oat0, tgtOat0, tMin, tMax, tStep, dtMin, dtMax, dtStep, true,
					true);
			lo.execute();

			Vector3D dv1 = lo.getDV1();
			Vector3D dv2 = lo.getDV2();
			double t = lo.getT();
			double dt = lo.getDT();
			double dv = dv1.getNorm();

			// Assert.assertEquals(5010501, lo.getCount());
			System.out.println(Utils.formatVector(dv1) + " " + Utils.formatVector(dv2) + " " + dv + " " + t + " " + dt);
			TestUtils.assertVectorRelativelyEquals(-53.8684534113, -5.4429244818, 38.1615193021, dv1, 1e-9);
			TestUtils.assertVectorRelativelyEquals(96.4589692851, -68.725636472, -25.1248120869, dv2, 1e-9);
			TestUtils.assertRelativelyEquals(140949.07831177983, t, 1e-9);
			TestUtils.assertRelativelyEquals(2648.0895141288584, dt, 1e-9);
		}
	}

	@Test
	public void test4() {
		Body b = new Body("Earth", 3.986004418E14);
		double mu = b.getMu();

		OrbitAtTime oat0 = new OrbitAtTime(b, new Vector3D(6217625.33521472, -719829.378348098, 1918106.38746952),
				new Vector3D(1657.6952993448, 7081.1412827167, -2921.2092857134));
		OrbitAtTime tgtOat0 = new OrbitAtTime(b, new Vector3D(5680511.51363976, -2590290.72677682, 2614657.68661689),
				new Vector3D(3839.9493325346, 6297.5479758191, -2114.4648415501));

		double tMin = 140904.28861779007;
		double tMax = 140904.28861779007;
		double tStep = 1;
		double dtMin = 2736.7284936812885;
		double dtMax = 2736.7284936812885;
		double dtStep = 1;

		// double tMin = 104817.865364057;
		// double tMax = 104817.865364057;
		// double tStep = 1;
		// double dtMin = 3589.71892698532;
		// double dtMax = 3589.71892698532;
		// double dtStep = 1;

		LambertOptimizer lo = new LambertOptimizer(mu, oat0, tgtOat0, tMin, tMax, tStep, dtMin, dtMax, dtStep, true,
				false);
		lo.execute();

		Vector3D dv1 = lo.getDV1();
		Vector3D dv2 = lo.getDV2();
		double t = lo.getT();
		double dt = lo.getDT();
		double dv = dv1.getNorm();

		// Assert.assertEquals(5010501, lo.getCount());
		System.out.println(dv1 + " " + dv2 + " " + dv + " " + t + " " + dt);
		TestUtils.assertVectorRelativelyEquals(79.2032486357, -259.367961919, -0.00045215772593656077, dv1, 1e-9);
		TestUtils.assertVectorRelativelyEquals(-164.2847412747, 424.4642747304, 0.0007407846716598644, dv2, 1e-9);
		TestUtils.assertRelativelyEquals(55459.662066626006, t, 1e-9);
		TestUtils.assertRelativelyEquals(5172.92991419679, dt, 1e-9);
	}
}
