package hall.john.ksp.mainframe;

import java.util.List;
import java.util.Map;
import java.util.HashMap;

public class Square {
  public static Map<String, Object> Square(List<String> args) {
    int x = Integer.parseInt(args.get(0));

	Map<String, Object> result = new HashMap<String, Object>();
	result.put("xSquared", x*x);

    return result;
  }
}
