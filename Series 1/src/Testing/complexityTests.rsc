module Testing::complexityTests

import Helpers;
import Complexity;

import Set;
import IO;
import String;

import lang::java::m3::Core;
import lang::java::m3::AST;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;

void complexityTests(){
	M3 model = createM3FromEclipseProject(|project://complexityTests|);
	list[Declaration] asts = getASTs(model);
	list[Declaration] projectMethods = toList(getMethods(asts));
	
	for (method <- projectMethods) {
		if (contains(method.src.file, "1")) assert cyclomaticComplexity(method) == 1;
		if (contains(method.src.file, "2")) assert cyclomaticComplexity(method) == 2;
		if (contains(method.src.file, "3")) assert cyclomaticComplexity(method) == 3;
	}
}

void runComplexityTests(){
	complexityTests();
}