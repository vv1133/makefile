extern void fun();
int main(int argc, const char *argv[])
{
#ifndef TEST
#error "test error"
#endif
	fun();
	return 0;
}
