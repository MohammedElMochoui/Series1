module Testing::volumeTests

import Helpers;

void test1(){
	assert countLinesOfCode(|project://volumeTests/src/volumeTest1.java|) == 5;
}

void test2(){
	assert countLinesOfCode(|project://volumeTests/src/volumeTest2.java|) == 5;
}

void test3(){
	assert countLinesOfCode(|project://volumeTests/src/volumeTest3.java|) == 5;
}

void test4(){
	assert countLinesOfCode(|project://volumeTests/src/volumeTest4.java|) == 8;
}

void runVolumeTests(){
	test1();
	test2();
	test3();
	test4();
}