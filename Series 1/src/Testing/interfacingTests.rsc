module Testing::interfacingTests

import Helpers;
import main;
import UnitInterfacing;

import Set;
import IO;
import String;

import lang::java::m3::Core;
import lang::java::m3::AST;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;

void test1(){
	M3 model = createM3FromEclipseProject(|project://interfacingTests|);
	list[Declaration] asts = getASTs(model);
	list[Declaration] projectMethods = toList(getMethods(asts));

	for (method <- projectMethods) {		
		int interfacing = unitInterfacing(method);
			
		if (contains(method.src.file, "1")) assert interfacing == 1;
		if (contains(method.src.file, "2")) assert interfacing == 0;
		if (contains(method.src.file, "3")) assert interfacing == 3;
	}
}

void runInterfacingTests(){
	test1();
}