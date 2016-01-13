package hall.john.ksp.mainframe;

public class Body {
	private String _name;
	private double _mu;

	public Body(String name, double mu) {
		_name = name;
		_mu = mu;
	}

	public String getName() {
		return _name;
	}

	public double getMu() {
		return _mu;
	}
}
