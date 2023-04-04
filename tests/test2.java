// testcase 2
public class For_nest {
    int f1;
    long f2;

    public int func(int a){
        int q = a + a;
        this.f1 = a;
        this.f2 = q;
    } 
    
    public void main(String[] args) {  
        for(int i=0;i<=10;i++){  
            for(int j=0;j<=5;j++){  
                System.out.println(i+"CS335"+j);  
            }
        }
    }  
   
}  