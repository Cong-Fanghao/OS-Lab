#include <stdio.h>
#include <ulib.h>

int global_var = 100;

int main(void) {
    int pid;
    int local_var = 200;

    cprintf("COW Test: Parent process starting...\n");
    cprintf("Before fork: global_var = %d, local_var = %d\n", global_var, local_var);

    pid = fork();

    if (pid == 0) {
        // === 子进程 ===
        cprintf("I am CHILD. Reading values (should be same)...\n");
        cprintf("CHILD: global_var = %d, local_var = %d\n", global_var, local_var);
        
        //这里进行写入操作！
        // 如果 COW 正常，此时 CPU 会触发 Page Fault，内核分配新物理页
        cprintf("CHILD: Modifying variables (Triggering COW)...\n");
        global_var = 300;
        local_var = 400;

        cprintf("CHILD: After modification: global_var = %d, local_var = %d\n", global_var, local_var);
        exit(0);
    } else {
        // === 父进程 ===
        int exit_code;
        waitpid(pid, &exit_code); // 等待子进程结束
        
        cprintf("I am PARENT. Child finished.\n");
        
        //检查父进程的值是否被修改
        // 如果 COW 正常，父进程的值应该保持不变（因为子进程改的是副本）
        if (global_var == 100 && local_var == 200) {
            cprintf("cow success!\n");
        } else {
            cprintf("FAILURE: Parent's variables were modified! COW failed.\n");
        }
    }
    return 0;
}