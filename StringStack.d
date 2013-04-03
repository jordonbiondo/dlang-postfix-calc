module StringStack;

import std.container;

/**
 * String stack
 * Represents a stack data structure that only contains strings.
 */
class StringStack {

  /**
   * The data is stored in an array called stack.
   */
  private SList!string stack;


  /*
   * Constructor.
   */
  this() {
    stack = SList!string();
  }


  /*
   * Push string onto the stack.
   */
  public void push(string s) {
    stack.stableInsertFront(s);
  }


  /*
   * Peek at the top element of the stack.
   */
  public string peek() {
    return (stack.empty ? null : stack.front());
  }


  /*
   * Pop top element off the stack and return it.
   */
  public string pop() {
    string r = peek();
    stack.stableRemoveFront();
    return r;
  }


  /*
   * Return the full array.
   */
  public SList!string getStack() {
    return stack;
  }

}

