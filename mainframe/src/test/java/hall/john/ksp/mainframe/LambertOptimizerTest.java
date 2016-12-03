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

		LambertOptimizer lo = new LambertOptimizer(mu, oat0, tgtOat0, tMin, tMax, tStep, dtMin, dtMax, dtStep, true,
				false);
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

	@Test
	public void test2() {
		Body b = new Body("Earth", 3.986004418E14);
		double mu = b.getMu();

		OrbitAtTime oat0 = new OrbitAtTime(b, new Vector3D(5507077.05790552, -3584709.45138777, -6.256561471),
				new Vector3D(4248.8908942288, 6527.4400999656, 0.0113926318));
		OrbitAtTime tgtOat0 = new OrbitAtTime(b, new Vector3D(5912477.98807351, -3299855.30599648, -5.7593520033),
				new Vector3D(3739.2505332585, 6699.759359006, 0.0116932746));

		double tMin = 0;
		double tMax = 120538.278779887 * 5;
		double tStep = 1205.38278779887 / 100;
		double dtMin = 5172.92991419679 / 5;
		double dtMax = 5672.92991419679 * 5;
		double dtStep = 1;

		LambertOptimizer lo = new LambertOptimizer(mu, oat0, tgtOat0, tMin, tMax, tStep, dtMin, dtMax, dtStep, true,
				false);
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

	/* Failing inputs:
	 *
	 * @formatter:off
	 *
	 * A Hohmann transfer works much better in this case.
	 *
	 * Waiting for requests
	 * Received request: lambertoptimize
	 * mu = 3.986004418E14
	 * r1 = {5,507,077.05790552; -3,584,709.45138777; -6.256561471}
	 * v1 = {4,248.8908942288; 6,527.4400999656; 0.0113926318}
	 * r2 = {5,912,477.98807351; -3,299,855.30599648; -5.7593520033}
	 * v2 = {3,739.2505332585; 6,699.759359006; 0.0116932746}
	 * tMin = 0.0
	 * tMax = 120538.278779887
	 * tStep = 1205.38278779887
	 * dtMin = 5172.92991419679
	 * dtMax = 5672.92991419679
	 * dtStep = 1.0
	 * allowLob = true
	 * dv1 = {-36.5706757418; 270.1618210816; 0.0004708914}
	 * dv2 = {67.9357223398; -443.0565321801; -0.0007730526}
	 * dv = 272.62579462439527
	 * t = 110895.21647749598
	 * dt = 5172.92991419679
	 *
	 * Waiting for requests
	 * Received request: lambertoptimize
	 * mu = 3.986004418E14
	 * r1 = {5,507,077.05790552; -3,584,709.45138777; -6.256561471}
	 * v1 = {4,248.8908942288; 6,527.4400999656; 0.0113926318}
	 * r2 = {5,912,477.98807351; -3,299,855.30599648; -5.7593520033}
	 * v2 = {3,739.2505332585; 6,699.759359006; 0.0116932746}
	 * tMin = 109689.833689697
	 * tMax = 112100.599265295
	 * tStep = 24.1076557559775
	 * dtMin = 4922.92991419679
	 * dtMax = 5422.92991419679
	 * dtStep = 1.0
	 * allowLob = true
	 * dv1 = {220.0342890534; -8.9588451393; -0.0000158569}
	 * dv2 = {-395.0563301927; -40.3534326321; -0.0000698572}
	 * dv = 220.21659625345606
	 * t = 109689.833689697
	 * dt = 4922.92991419679
	 *
	 * Waiting for requests
	 * Received request: lambertoptimize
	 * mu = 3.986004418E14
	 * r1 = {5,507,077.05790552; -3,584,709.45138777; -6.256561471}
	 * v1 = {4,248.8908942288; 6,527.4400999656; 0.0113926318}
	 * r2 = {5,912,477.98807351; -3,299,855.30599648; -5.7593520033}
	 * v2 = {3,739.2505332585; 6,699.759359006; 0.0116932746}
	 * tMin = 109639.833689697
	 * tMax = 109739.833689697
	 * tStep = 1.0
	 * dtMin = 4672.92991419679
	 * dtMax = 5172.92991419679
	 * dtStep = 1.0
	 * allowLob = true
	 * dv1 = {203.7132842996; -67.0723476057; -0.0001171758}
	 * dv2 = {-389.775322167; 28.1278942202; 0.0000496209}
	 * dv = 214.47098175155557
	 * t = 109639.833689697
	 * dt = 4814.92991419679
	 *
	 * @formatter:on
	 */
}
