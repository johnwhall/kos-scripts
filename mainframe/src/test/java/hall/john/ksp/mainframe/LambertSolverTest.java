package hall.john.ksp.mainframe;

import static org.junit.Assert.assertEquals;

import org.apache.commons.math3.geometry.euclidean.threed.Vector3D;
import org.junit.Test;

import hall.john.ksp.mainframe.LambertSolver.Solution;

public class LambertSolverTest {
	private static Vector3D rotateVector(Vector3D v, double angleRads) {
		double x = v.getX();
		double y = v.getY();
		double z = v.getZ();
		double sin = Math.sin(angleRads);
		double cos = Math.cos(angleRads);
		return new Vector3D(x * cos - y * sin, x * sin + y * cos, z);
	}

	private static void assertSolutionEquals(double v1x, double v1y, double v1z, double v2x, double v2y, double v2z, double a, Solution sol) {
		TestUtils.assertRelativelyEquals(v1x, sol.v1.getX(), 1e-4);
		TestUtils.assertRelativelyEquals(v1y, sol.v1.getY(), 1e-4);
		TestUtils.assertRelativelyEquals(v1z, sol.v1.getZ(), 1e-4);
		TestUtils.assertRelativelyEquals(v2x, sol.v2.getX(), 1e-4);
		TestUtils.assertRelativelyEquals(v2y, sol.v2.getY(), 1e-4);
		TestUtils.assertRelativelyEquals(v2z, sol.v2.getZ(), 1e-4);
		TestUtils.assertRelativelyEquals(a, sol.angle, 1e-4);
	}

	@Test
	public void test1() {
		double mu = 398603.0 * 1000 * 1000 * 1000;
		Vector3D r1Vec = new Vector3D(10000000, 0, 0);
		Vector3D r2Vec = rotateVector(r1Vec.scalarMultiply(1.6), Math.toRadians(100));
		LambertSolver ls = new LambertSolver(mu, r1Vec, r2Vec, 3072, 0, true);
		ls.solve();
		assertEquals(1, ls.getSolutions().size());
		assertSolutionEquals(-377.3168363349114, 7889.69293204125, 0, -5352.761738375782, 1960.1885952794946, 0, 1.7453292519943295, ls.getSolutions().get(0));
	}

	@Test
	public void test2() {
		double mu = 398603.0 * 1000 * 1000 * 1000;
		Vector3D r1Vec = new Vector3D(10000000, 0, 0);
		Vector3D r2Vec = rotateVector(r1Vec.scalarMultiply(1.6), Math.toRadians(260));
		LambertSolver ls = new LambertSolver(mu, r1Vec, r2Vec, 31645, 0, true);
		ls.solve();
		assertEquals(1, ls.getSolutions().size());
		assertSolutionEquals(377.4228058979588, 7889.7602524861995, 0, 5352.825254283218, 1960.3065100210342, 0, 4.537856055185256, ls.getSolutions().get(0));
	}

	@Test
	public void test3() {
		double mu = 398603.0 * 1000 * 1000 * 1000;
		Vector3D r1Vec = new Vector3D(10000000, 0, 0);
		Vector3D r2Vec = rotateVector(r1Vec.scalarMultiply(1.6), Math.toRadians(260));
		LambertSolver ls = new LambertSolver(mu, r1Vec, r2Vec, 31645, 0, false);
		ls.solve();
		assertEquals(1, ls.getSolutions().size());
		assertSolutionEquals(6373.561127399767, -4673.784071715375, 0, -2025.35758066653, 5335.657472529362, 0, 1.7453292519943302, ls.getSolutions().get(0));
	}

	@Test
	public void test4() {
		double mu = 398603.0 * 1000 * 1000 * 1000;
		Vector3D r1Vec = new Vector3D(10000000, 0, 0);
		Vector3D r2Vec = rotateVector(r1Vec.scalarMultiply(1.6), Math.toRadians(260));
		LambertSolver ls = new LambertSolver(mu, r1Vec, r2Vec, 31645, 1, false);
		ls.solve();
		assertEquals(3, ls.getSolutions().size());
		assertSolutionEquals(6373.561127399767, -4673.784071715375, 0, -2025.35758066653, 5335.657472529362, 0, 1.7453292519943302, ls.getSolutions().get(0));
		assertSolutionEquals(5154.48441880469, -5109.118189834746, 0, -2528.785182492637, 4047.445960381232, 0, 8.028514559173917, ls.getSolutions().get(1));
		assertSolutionEquals(-139.89148838325855, -7740.2603938265975, 0, -5211.391732574132, -1696.2817579697057, 0, 8.028514559173917, ls.getSolutions().get(2));
	}
}
