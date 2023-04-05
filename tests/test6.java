//testcase6
class Iam {
    boolean ok;
    Iam(boolean a){
      this.ok = a;
    }
    public static void abc(int a, int b) {
      int q = a+5;
      int r = b + 6;
      this.ok = false;
      System.out.println("false");
    }

  }
  
  class You {
    public static long main(String[] args, float abc , long quo) {
      int a = 3;
      float b = 7;
      double c = 9.0;
      Iam itis = new Iam(false);
      itis.abc(6,5);
    }

  }



