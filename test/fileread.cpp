#include <stdio.h>
#include <stdlib.h>

#define filename "/export/home2/cuc1057/test/rand_data"
int main()
{
   int num;
   FILE *fptr;
   char* buffer = NULL;
   size_t result; 
   size_t lSize = 128;

   // use appropriate location if you are using MacOS or Linux
   fptr = fopen(filename,"rb");

   if(fptr == NULL)
   {
      printf("Error!");   
      exit(1);             
   }
     
   buffer = (char*) malloc (sizeof(char)*lSize);
   if (buffer == NULL) {fputs ("Memory error",stderr); exit (2);}

   result = fread (buffer, 1, lSize, fptr);
   if (ferror(fptr)) fprintf(stderr, "Error Reading\n");
   if (feof(fptr)) fprintf(stderr, "End of File\n");
   if (result != lSize) {fputs ("Read Size doesn't match\n",stderr); exit (3);}

   for (auto i = 0; i < lSize; i++) fprintf(stderr, "%x\n", buffer[i]&0xff);
   fprintf(stderr, "\n");

   free(buffer);
   fclose(fptr);

   return 0;
}
