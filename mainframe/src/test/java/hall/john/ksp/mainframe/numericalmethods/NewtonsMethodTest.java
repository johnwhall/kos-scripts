package hall.john.ksp.mainframe.numericalmethods;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNull;

import java.util.function.DoubleFunction;

import org.junit.Test;

public class NewtonsMethodTest {

	@Test
	public void convergeTest() {
		DoubleFunction<Double> f = (double x) -> x*x - 612;
		DoubleFunction<Double> fp = (double x) -> 2*x;
		NewtonsMethod mth = new NewtonsMethod(f, fp, 10, 10, 1e-6);
		mth.execute();
		assertTrue(mth.getConverged());
		assertEquals(24.7386337537, mth.getResult(), 1e-6);
	}

	@Test
	public void maxIterTest() {
		DoubleFunction<Double> f = (double x) -> x*x*x -2*x + 2;
		DoubleFunction<Double> fp = (double x) -> 3*x*x -2;
		NewtonsMethod mth = new NewtonsMethod(f, fp, 0, 10, 1e-6);
		mth.execute();
		assertFalse(mth.getConverged());
		assertNull(mth.getResult());
	}

	@Test
	public void zeroDerivativeTest() {
		DoubleFunction<Double> f = (double x) -> x*x*x -2*x + 2;
		DoubleFunction<Double> fp = (double x) -> 0.0;
		NewtonsMethod mth = new NewtonsMethod(f, fp, 0, 10, 1e-6);
		mth.execute();
		assertFalse(mth.getConverged());
		assertNull(mth.getResult());
	}
}
