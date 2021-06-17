#include <stdio.h>
#include <time.h>
#include <stdlib.h>

int main(){
	clock_t start, end;
	double cpu_time_used,info,singlesSum,doublesSum;
	int i,j,k,count_outer,count_back,number;
	char fname[128];
	//char wname[128];
	printf("Enter the total number of particles\n");
	scanf("%d",&number);
	printf("Numbe =%d\n",number);
	printf("Enter .txt file name\n");
	scanf("%s",fname);
	printf("File =%s\n",fname);
	//printf("Enter the output file .txt\n");
	//scanf("%s",wname);
	//printf("Output=%s\n",wname);
		

	start = clock();
	//char *filename = "test.txt";
	int count =0;
	FILE *fp = fopen(fname, "r");
	//FILE *wp = fopen(wname,"w");

	if(fp == NULL){
		printf("Error:cound not open file %s", fname);
		return 1;
	}	

	//reading line by line
	
	const unsigned MAX_LENGTH = 256;
	char buffer[MAX_LENGTH];
	
	singlesSum =0;
	doublesSum =0;
	count_outer =0;
	count_back =0;
	double  eng[32][2]={{1,1.1},{1.1,1.2},{1.2,1.3},{1.3,1.4},{1.4,1.5},{1.5,1.6},{1.6,1.7},{1.7,1.8},{1.8,1.9},{1.9,2},{2,2.1},{2.1,2.21},{2.21,2.32},{2.32,2.44},
				{2.44,2.56},{2.56,2.69},{2.69,2.83},{2.83,2.97},{2.97,3.12},{3.12,3.28},{3.28,3.45},{3.45,3.62},{3.62,3.81},{3.81,4},{4,4.2},{4.2,4.5},
				{4.5,4.8},{4.8,5.2},{5.2,5.6},{5.6,6},{6,6.5},{6.5,7}};

	int output[32];
	
	//while(fgets(buffer,MAX_LENGTH,fp)){
		for(i=0;i<number;i++){
			//count++;
			//printf("count=%d\n",count);
			for(j=0;j<18;j++){
				fgets(buffer,MAX_LENGTH,fp);
				info = strtod(buffer, NULL);
				if ((j % 2 ==1) && (j<16))
					singlesSum = singlesSum +info;
				
				if ((j % 2 ==0) && (j<18) && (j>1))
					doublesSum =doublesSum + info;
				
				if ((j==17) && (doublesSum>0)){
					count_outer=count_outer +1;;
					singlesSum = 0;
					}
				
				if ((j == 17) && (info>0)){
					count_back = count_back +1;;
					singlesSum =0;
					}
				if(j == 17){
					for(k=0;k<32;k++){
						if((singlesSum>= eng[k][0]) && (singlesSum<eng[k][1]))
							output[k]=output[k]+1;
					}
				}
			}
		singlesSum =0;
		doublesSum =0;		
		}
		
//}
	
	fclose(fp);
	for(k=0;k<32;k++){
		printf("a[%d] = %f\n", k, (double)output[k]/number);
		}
	end = clock();
	cpu_time_used = ((double)(end -start)) / CLOCKS_PER_SEC;
	printf("time used is %f\n",cpu_time_used);
	printf("outer_ring =%d\n",count_outer);
	printf("hit_back =%d\n",count_back);
	return 0;	
}
