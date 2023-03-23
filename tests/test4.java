//testCASE4
public class Main {
  String str;
  int x[] = {1, 2, 3};
  
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
      // int y[] = {4, 3, 5};
    }

    public static void somefunc(String arg1, int arg2) {}
  }