DC=dmd
TESTFLAGS=-unittest
BINDIR=bin
BINNAME=InfixPostfix
TESTNAME=Test_InfixPostfix


default: $(BINDIR)/$(BINNAME);

$(BINDIR)/$(BINNAME): InfixPostfix.d Operator.d StringStack.d
	mkdir -p $(BINDIR); $(DC) -of$(BINDIR)/$(BINNAME) $^

test: $(BINDIR)/$(TESTNAME)
$(BINDIR)/$(TESTNAME): InfixPostfix.d Operator.d StringStack.d
	mkdir -p $(BINDIR);$(DC) $(TESTFLAGS) -of$(BINDIR)/$(TESTNAME) $^

clean:
	rm -f *~ $(BINDIR)/*
