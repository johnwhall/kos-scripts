package hall.john.ksp.mainframe;

import static org.junit.Assert.assertTrue;

import org.apache.commons.math3.geometry.euclidean.threed.Vector3D;

public abstract class TestUtils {
	private TestUtils() {
		// don't construct me!
	}

	public static void assertRelativelyEquals(double a, double b, double eps) {
		if (a == 0) assertTrue("Got " + b + ", expected " + a, Math.abs(b) < eps);
		else if (b == 0) assertTrue("Got " + b + ", expected " + a, Math.abs(a) < eps);
		else assertTrue("Got " + b + ", expected " + a, Math.abs((a - b) / a) < eps);
	}

	public static void assertVectorRelativelyEquals(Vector3D u, Vector3D v, double eps) {
		assertRelativelyEquals(u.getX(), v.getX(), eps);
		assertRelativelyEquals(u.getY(), v.getY(), eps);
		assertRelativelyEquals(u.getZ(), v.getZ(), eps);
	}

	public static void assertVectorRelativelyEquals(double x, double y, double z, Vector3D v, double eps) {
		assertVectorRelativelyEquals(new Vector3D(x, y, z), v, eps);
	}
}
