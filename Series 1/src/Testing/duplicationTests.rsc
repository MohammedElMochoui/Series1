module Testing::duplicationTests

import Helpers;
import Duplication;

import Set;
import IO;
import String;

import lang::java::m3::Core;
import lang::java::m3::AST;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;

void test1(){
	M3 model = createM3FromEclipseProject(|project://duplicationTests|);
	assert codeDuplication(model) == 0;
}

void test2(){
	M3 model = createM3FromEclipseProject(|project://duplicationTests2|);
	assert codeDuplication(model) == 0;
}

void test3(){
	M3 model = createM3FromEclipseProject(|project://duplicationTests3|);
	assert codeDuplication(model) == 12;
}

void test4(){
	M3 model = createM3FromEclipseProject(|project://duplicationTests4|);
	assert codeDuplication(model) == 13;
}

void test5(){
	M3 model = createM3FromEclipseProject(|project://duplicationTests5|);
	assert codeDuplication(model) == 7;
}

void test6(){
	M3 model = createM3FromEclipseProject(|project://duplicationTests6|);
	assert codeDuplication(model) == 12;
}

void runDuplicationTests(){
	test1();
	test2();
	test3();
	test4();
	test5();
	test6();
}
