//testCASE4
public class Main {
  String str;
  
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
    }

    public static void somefunc(String arg1, int arg2) {}
  }