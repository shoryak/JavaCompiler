
//testcase6
class Iam {
  public
    int a;
    long f2;
    long f3;
    Iam(int a , long f3 , long f2){
      this.a = a;
      this.f3 = f3;
      this.f2 = f2;
    }
    public int abc(Iam f, int b) {
      int q = f.a+5;
      System.out.println( f.a);
      System.out.println(this.a);
      q = (f.a + this.a);
      System.out.println(q );
      return this.a;
    }

  }
  
  class You {
    public static void qr(){
      System.out.println("abc");
    }

    public static long main(String[] args, float abc , long quo) {
      int a = 908;
      Iam itis = new Iam(908, 50 , 100);
      Iam itis2 = new Iam(100 ,  300 , 200);
      long k = itis.a + itis2.f3;
      System.out.println(itis.abc(itis2,3));
      qr();
    }

  }



