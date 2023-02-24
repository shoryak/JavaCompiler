public class DiffOddEven {    
        
    //Represent a node of binary tree    
    public static class Node{    
        int data;    
        Node left;    
        Node right;    
            
        public Node(int data){    
            //Assign data to the new node, set left and right children to null    
             this.data = data;    
             this.left = null;    
             this.right = null;    
            }    
        }    
        
    //Represent the root of binary tree    
    public Node root;    
      
    public DiffOddEven(){    
        root = null;    
    }

     
}

      