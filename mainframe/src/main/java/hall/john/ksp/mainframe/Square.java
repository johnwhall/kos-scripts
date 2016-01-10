package hall.john.ksp.mainframe;

import java.util.List;

public class Square {
  public static String Square(List<String> args) {
    int x = Integer.parseInt(args.get(0));
    return Integer.toString(x*x);
  }
}
