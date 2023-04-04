//testCase4
public class Ifelsedemo{  

    int f1;
    long f2;

    Ifelsedemo(int a){
        this.f2 = a;
    } 
    
    public void ifelse(){
        int p=2;
      if(p<9){  
          System.out.println("I am p");  
          if(p == 2){
              System.out.println("2 here");  
          }
      }
      else{  
          System.out.println("I am p as well");  
      }  
    }

    public static void main(String[] args) {  
        int p = 10;
        Ifelsedemo obj = new Ifelsedemo(p);
        obj.f1 = 8;
    }  
} 

