public class EmptyClass {
    String regex = "\\d+\\s*\\w+";
    String testString = "123    Test";
    //System.out.println(testString.matches(regex));
    int x = 5;
int y = 2;
int result1 = x + y; // 7
int result2 = x - y; // 3
int result3 = x * y; // 10
int result4 = x / y; // 2
int result5 = x % y; // 1
int result6 = ++x; // 6
int result7 = --y; // 1
int result8 = x++; // 6
int result9 = y--; // 1

int x = 5;
int y = 2;
boolean result1 = x == y; // false
boolean result2 = x != y; // true
boolean result3 = x > y; // true
boolean result4 = x < y; // false
boolean result5 = x >= y; // true
boolean result6 = x <= y; // false

int x = 5; // 101 in binary
int y = 2; // 010 in binary
int result1 = x & y; // 000 (0 in decimal)
int result2 = x | y; // 111 (7 in decimal)
int result3 = x ^ y; // 111 (7 in decimal)
int result4 = ~x; // 11111111111111111111111111111010 (-6 in decimal)
int result5 = x << 1; // 1010 (10 in decimal)
int result6 = y >> 1; // 001 (1 in decimal)
int result7 = x >>> 1; // 010 (2 in decimal)

boolean a = true;
boolean b = false;
boolean result1 = a && b; // false
boolean result2 = a || b; // true
boolean i = result1/result2;

boolean a = true;
boolean b = false;
boolean result1 = a && b; // false
boolean result2 = a || b; // true
boolean result3 = !a; // false

boolean a = true;
boolean b = false;
boolean result1 = a && b; // false
boolean result2 = a || b; // true
boolean result3 = !a; // false

int x = 5;
int y = 2;
int result = (x > y) ? x : y; // result is 5

float a=2;
long b=c--;
double i = result;

int[][][] array3D = new int[2][3][4];

array3D[0][1][2] = 5; // Sets the value of the element at (0, 1, 2) to 5
int element = array3D[1][2][3]; // Retrieves the value of the element at (1, 2, 3)

for (int i = 0; i < 2; i++) {
    for (int j = 0; j < 3; j++) {
        for (int k = 0; k < 4; k++) {
            System.out.println("Element at (" + i + ", " + j + ", " + k + "): " + array3D[i][j][k]);
        }
    }
}

if (x==0) {
    // code to execute if the condition is true
    int a=2;
} else {
    // code to execute if the condition is false
    a=3;
}

int[] numbers = {1, 2, 3, 4, 5};
for (int i = 0; i < numbers.length; i++) {
    if (numbers[i] % 2 == 0) {
        System.out.println(numbers[i] + " is even.");
    } else {
        System.out.println(numbers[i] + " is odd.");
    }
}

int i = 0;
while (i < numbers.length) {
    if (numbers[i] % 2 == 0) {
        System.out.println(numbers[i] + " is even.");
    } else {
        System.out.println(numbers[i] + " is odd.");
    }
    ++i;
    --i;
    i--;
    j++;
}




}