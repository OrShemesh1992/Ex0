#!make -f
CXX=clang++-5.0
CXXFLAGS=-std=c++17 -pthread

all:
	$(CXX) $(CXXFLAGS) *.cpp
#	./a.out
