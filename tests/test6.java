//testcase6
class Iam {
  
    boolean ok;
    public void abc(int a, int b) {
      int q = a+5;
      int r = b + 6;
      ok = false;
      System.out.println("false");
    }

  }
  
  class Main {
    public static long main(String[] args, float abc , long quo) {
      int a = 3;
      float b = 7;
      double c = 9.0;
      // create object
   

     Iam itis = new Iam();
      int arr[] = new int[5];
      int x = 90;
      boolean p = a < x;
      itis.abc(6,5);
      // x.abc(4);

    
    }
  }

/*
  arguments pop in the callee management  (done)
  calculating total size of the local variables (done)
  All non-static methods will have a this pointer as the first param (done but static ka dekn method invo main etc)
  num*callee saved = fix  number decide karo aur daaldo (9 taken , done)
  return, return value set (done )



  array access code check karna
  methodInvocation (pop total sum pop  and static )
  MethodDeclaration 
  constructor_declaration  (done almost, check it allomem left , add this to popparams)  
  println theek karo 
  
*/

