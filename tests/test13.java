public class Test13 {    
    public static void main(String[] args) {    
        int yr = 2000;    
        if((yr%400==0) || ((yr%100 !=0) && (yr%4 ==0))){  
            System.out.println("This is leap year");
            if(yr<=1800){
                System.out.println("Ancient Time !");
                if(yr/100<100){
                    System.out.println("Very Ancient Time !");
                }
            }
            else if(yr>200+2*1600/2-100+100){
                System.out.println("Not that much Ancient Time !");
            }
        }  
        else{  
            System.out.println("Not a leap year");  
        }  
    }    
}    