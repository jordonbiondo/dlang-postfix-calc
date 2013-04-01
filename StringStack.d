module StringStack;

import std.stdio;
import std.array;
import std.conv;
import std.algorithm;
import std.string;


/**
 * String stack
 * Represents a stack data structure that only contains strings.
 */
class StringStack {

  /**
   * The data is stored in an array called stack.
   */
  private string[] stack;


  /*
   * Constructor.
   */
  this() {
    stack = new string[0];
  }


  /*
   * Push string onto the stack.
   */
  public void push(string s) {
    stack.insertInPlace(0, s);
  }


  /*
   * Peek at the top element of the stack.
   */
  public string peek() {
    return (stack.length == 0 ? null : stack.front());
    //return stack.front();
  }


  /*
   * Pop top element off the stack and return it.
   */
  public string pop() {
    string r = peek();
    stack.popFront();
    return r;
  }


  /*
   * Return the full array.
   */
  public string[] getStack() {
    return stack;
  }

}

