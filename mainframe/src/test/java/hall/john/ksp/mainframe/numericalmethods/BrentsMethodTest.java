package hall.john.ksp.mainframe.numericalmethods;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNull;

import java.util.function.DoubleFunction;

import org.junit.Test;

public class BrentsMethodTest {

	@Test
	public void convergeTest() {
		DoubleFunction<Double> f = (double x) -> (x + 3) * (x - 1) * (x - 1);
		BrentsMethod mth = new BrentsMethod(f, -4, 4.0/3, 100, 1e-6);
		mth.execute();
		assertTrue(mth.getConverged());
		assertEquals(-3, mth.getResult(), 1e-6);
	}

	@Test
	public void maxIterTest() {
		DoubleFunction<Double> f = (double x) -> (x + 3) * (x - 1) * (x - 1);
		BrentsMethod mth = new BrentsMethod(f, -4, 4.0/3, 1, 1e-6);
		mth.execute();
		assertFalse(mth.getConverged());
		assertNull(mth.getResult());
	}

	@Test
	public void unboundedTest() {
		DoubleFunction<Double> f = (double x) -> (x + 3) * (x - 1) * (x - 1);
		BrentsMethod mth = new BrentsMethod(f, 2, 4, 100, 1e-6);
		mth.execute();
		assertFalse(mth.getConverged());
		assertNull(mth.getResult());
	}
}
