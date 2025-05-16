#include<stdio.h>
#include<stdbool.h>

void main(){
  int num = 85821;       // Assuming the number to always be non-zero
  int digit_count = 0;
  
  while (true) {
    num /= 10;
    digit_count++;

    if (num == 0){
      break;
    }
  }
  printf("digits: %d", digit_count);
}