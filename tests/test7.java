// testcase7
public class Recursion_ex { 
  public
    static long fact(int n)
    { 

      if(n < 0)
        return 10;
      else if (n == 0)
            return 1;
      else{
            long val = fact(n-1)*n;
            System.out.println(val);
            return val;
      }
    }      
  
    public static void main(String[] args) {
      long p = fact(20);
    }  
    // this is example of factorial
}  