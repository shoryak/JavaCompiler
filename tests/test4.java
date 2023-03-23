//testCASE4
public class B
{
  int bint;
}
public class Adder
{
  B objb;
}
public class Main {
  public static String str = "Hello";
  // int[] x[] = {1, 2, 3};
  int[][] y[] = {2, 3, 4};
  
    static void myStatMethod() {
      System.out.println("Static is better or not");
    }
  
    public void Public__Method(int x, int y) {
      System.out.println("Public is better or not");
    }
  
    public static void main(String[] args) {
      myStatMethod(); // Static is better
  
      
      Main myObject = new Main(); 
      int a=1, b=2;
      myObject.Public__Method(a, b);  
      myObject.str = "Hello World!";
      Adder add = new Adder();
      B bobj = new B();
      bobj.bint = 2;
      // int y[] = {4, 3, 5};
    }

    public static void somefunc(String arg1, int arg2) {}
  }