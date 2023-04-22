//testCase4
public class Ifelsedemo{  
public
    int f1;
    long f2;

    Ifelsedemo(int f1 , long f2){
        this.f1 = f1;
        this.f2 =  f2;
    } 

    public static void main(String[] args) {  
        Ifelsedemo obj  = new Ifelsedemo(10,30);
        System.out.println(obj.f1);
        System.out.println(obj.f2);
        obj.f2 = 200;
        System.out.println(obj.f2 + 2*obj.f1);
        return;
    }  
} 

