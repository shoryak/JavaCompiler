// testcase7
public class Recursion_ex {  
    static int fact(int n){      
          if (n == 0)      
            return 1;      
          else      
            return(fact(n-1)*n);      
    }      
  
    public static void main(String[] args) {  
        System.out.println(" example of fact: "+fact(10));  
    }  
    // this is example of factorial
}  