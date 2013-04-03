module InfixPostfix;

import StringStack;
import Operator;

import std.stdio;
import std.array;
import std.conv;
import std.container;
import std.algorithm;
import std.regex;
import std.string;

/*
 * Infix to Postfix
 * Translates infix math strings to post fix and can evaluate post fix calculations
 */
class InfixPostfix {
  /*
   * String indexed map of Operators
   */
  Operator[string] operators;

  /*
   * Constructor
   */
  this() {
    operators = [
		 "+": new Operator("+", 1, 1,(a, b) => to!int(a) + to!int(b)),
		 "-": new Operator("-", 1, 1, (a, b) => to!int(a) - to!int(b)),
		 "*": new Operator("*", 2, 2, (a, b) => to!int(a) * to!int(b)),
		 "/": new Operator("/", 2, 2, (a, b) => to!int(a) / to!int(b)),
		 "%": new Operator("%", 2, 2, (a, b) => to!int(a) % to!int(b)),
		 "^": new Operator("^", 4, 3, (a, b) => to!int(a) ^^ to!int(b)),
		 "(": new Operator("(", 5, -1, null)];
  }


  /*
   * Infix To Postfix
   */
  public string infixToPostfix(string exprStr) {
    StringStack stack = new StringStack;
    StringStack expression = new StringStack;
    foreach(token; split(exprStr)) {
      if (isOperand(token)) {
	expression.push(token);
      } else if (isLeftParen(token)) {
	stack.push(token);
      } else if (isOperator(token)) {
	while (isOperator(stack.peek)) {
	  if (stackPrecedence(stack.peek) < inputPrecedence(token)) {
	    break;
	  } else {
	    expression.push(stack.pop);
	  }
	}
	stack.push(token);
      } else if (isRightParen(token)) {
	while (isOperator(stack.peek)) {
	  if (! isLeftParen(stack.peek)) {
	    expression.push(stack.pop);
	  } else {
	    stack.pop;
	    break;
	  }
	}
      }
    }
    foreach(x; stack.getStack) {
      expression.push(x);
    }
    return  strip(reduce!((a, b) => b ~ " " ~ a)("", expression.getStack));
  }


  /*
   * Evaluate Postfix expression
   */
  public int evaluatePostfix(string exprStr) {
    StringStack stack = new StringStack();
    foreach(immutable string token; split(exprStr)) {
      if (isOperand(token) ) {
	stack.push(token);
      } else if (isOperator(token)) {
	auto y = stack.pop;
	auto x = stack.pop;
	stack.push(to!string(applyOperator(x, y, token)));
      }
    }
    return to!int(stack.pop);
  }


  /// True is str is an operator
  private bool isOperator(immutable string str) {
    return ! find(operators.keys, str).empty;
  }


  /// true if str is an operand (number)
  private bool isOperand(immutable string str) {
    return ! match(str, regex("^[0-9]+$")).empty;
  }


  /// true if str is a left parenthesis
  private bool isLeftParen(immutable string str) {
    return str == "(";
  }


  /// true is str is a right parenthesis
  private bool isRightParen(immutable string str) {
    return str == ")";
  }


  /// return the stack pre.cendence of an operator
  private int stackPrecedence(immutable string operator) {
    return operators[operator].stackPrecedence;
  }


  /// return the input precendence of an operator
  private int inputPrecedence(immutable string operator) {
    return operators[operator].inputPrecedence;
  }


  /// return the result of applying operator to num1 and num2
  private int applyOperator(string num1, string num2, string operator) {
    return operators[operator].operation(to!int(num1), to!int(num2));
  }


  // /////////////////////////////////////////////////////////////////
  //   Unit testing for InfixPostfix
  // /////////////////////////////////////////////////////////////////
  unittest {

    // time the testing
    import core.time;
    auto x = TickDuration.currSystemTick().length;

    InfixPostfix ifpf = new InfixPostfix;
    //    left paren
    assert(ifpf.isLeftParen("("));
    assert(!ifpf.isLeftParen("d"));

    assert(! ifpf.isLeftParen(" ("));
    assert(! ifpf.isLeftParen(")"));

    //right
    assert(ifpf.isRightParen(")"));
    assert(! ifpf.isRightParen(" )"));
    assert(! ifpf.isRightParen("("));

    // is operand
    assert(ifpf.isOperand("10"));
    assert(ifpf.isOperand("3"));
    assert(ifpf.isOperand("111"));
    assert(ifpf.isOperand("0"));
    assert( ! ifpf.isOperand("/10"));
    assert( ! ifpf.isOperand("//"));
    assert(! ifpf.isOperand("nope"));


    // is operator
    assert(ifpf.isOperator("+"));
    assert(ifpf.isOperator("-"));
    assert(ifpf.isOperator("*"));
    assert(ifpf.isOperator("/"));
    assert(! ifpf.isOperator("10"));
    assert(! ifpf.isOperator("//"));
    assert(! ifpf.isOperator("+10"));
    assert(! ifpf.isOperator("2^"));


    //apply operator
    assert(2 == ifpf.applyOperator("1", "1", "+"));
    assert(2 == ifpf.applyOperator("29", "10", "/"));
    assert(0 == ifpf.applyOperator("10", "29", "/"));
    assert(16 == ifpf.applyOperator("4", "2", "^"));
    assert(2 == ifpf.applyOperator("4", "2", "-"));
    assert(2 == ifpf.applyOperator("18", "8", "%"));
    assert(16 == ifpf.applyOperator("2", "8", "*"));


    // infix to postfix translation tests
    assert("3 4 2 5 ^ - * 6 +" == ifpf.infixToPostfix("3 * ( 4 - 2 ^ 5 ) + 6"));
    assert("3 2 1 2 + ^ ^" == ifpf.infixToPostfix("3 ^ 2 ^ ( 1 + 2 )"));
    assert("10 2 2 2 ^ ^ * 10 50 * +" == ifpf.infixToPostfix("10 * ( 2 ^ 2 ^ 2 ) + 10 * 50"));
    assert("100 50 2 3 ^ - / 50 10 / - 5 +" == ifpf.infixToPostfix("100 / ( 50 - 2 ^ 3 ) - 50 / 10 + 5"));
    assert("10 54 10 % 25 10 - 2 2 ^ + * 3 / +" == ifpf.infixToPostfix("10 + 54 % 10 * ( 25 - 10 + 2 ^ 2 ) / 3"));
    assert("10 5 2 % + 5 3 3 ^ * + 25 5 / -" == ifpf.infixToPostfix("( 10 + 5 % 2 ) + ( 5 * 3 ^ 3 ) - ( 25 / 5 )"));

    // postfix evaluation tests
    assert(-78== ifpf.evaluatePostfix("3 4 2 5 ^ - * 6 +"));
    assert(6561== ifpf.evaluatePostfix("3 2 1 2 + ^ ^"));
    assert(660== ifpf.evaluatePostfix("10 2 2 2 ^ ^ * 10 50 * +"));
    assert(2== ifpf.evaluatePostfix("100 50 2 3 ^ - / 50 10 / - 5 +"));
    assert(35== ifpf.evaluatePostfix("10 54 10 % 25 10 - 2 2 ^ + * 3 / +"));
    assert(141== ifpf.evaluatePostfix("10 5 2 % + 5 3 3 ^ * + 25 5 / -"));
    // print testing time
    float timeTaken = (to!float(TickDuration.currSystemTick().length - x))/TickDuration.ticksPerSec;
    writeln(timeTaken, " seconds for testing");
  }
}


// /////////////////////////////////////////////////////////////////
//   Main
// /////////////////////////////////////////////////////////////////
void main() {
}
