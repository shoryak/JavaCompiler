// testcase7
public class Recursion_ex {  
    static int fact(int n)
    { 
      if(n < 0)
        return 10;
      else if (n == 0)
            return 1;
      else
            return(fact(n-1)*n);
    }      
  
    public static void main(String[] args) {
      if(1 < 2) System.out.println(10);
      if(2 < 1) System.out.println(11);
      if(1 <= 2) System.out.println(12);
      if(2 <= 1) System.out.println(13);
      if(2 > 1) System.out.println(14);
      if(1 > 2) System.out.println(15);
      if(2 >= 1) System.out.println(16);
      if(1 >= 2) System.out.println(17);
      if(1 == 1) System.out.println(18);
      if(1 == 2) System.out.println(19);
      if(1 != 2) System.out.println(20);
      if(1 != 1) System.out.println(21);
    }  
    // this is example of factorial
}  