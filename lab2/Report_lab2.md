# Lab2 �����ڴ���ҳ�� ʵ�鱨��
**С���Ա���Է��_2310682��Ǯչ��_2312479�������_2312594**

## ��������
- ��ϰ1�����first-fit ���������ڴ�����㷨
first-fit ���������ڴ�����㷨��Ϊ�����ڴ����һ���ܻ����ķ�������Ҫͬѧ���������ʵ�ֹ��̡�������ϸ�Ķ�ʵ���ֲ�Ľ̳̲����kern/mm/default_pmm.c�е���ش��룬�������default_init��default_init_memmap��default_alloc_pages�� default_free_pages����غ����������������ڽ��������ڴ����Ĺ����Լ��������������á� ����ʵ�鱨���м�Ҫ˵��������ʵ�ֹ��̡���ش��������⣺
���first fit�㷨�Ƿ��н�һ���ĸĽ��ռ䣿

- ��ϰ2��ʵ�� Best-Fit ���������ڴ�����㷨
�������ϰһ�󣬲ο�kern/mm/default_pmm.c��First Fit�㷨��ʵ�֣����ʵ��Best Fitҳ������㷨���㷨��ʱ�ո��ӶȲ���Ҫ����ͨ�����Լ��ɡ� ����ʵ�鱨���м�Ҫ˵��������ʵ�ֹ��̣�������������ζ������ڴ���з�����ͷţ����ش��������⣺
��� Best-Fit �㷨�Ƿ��н�һ���ĸĽ��ռ䣿

## first-fit������������㷨����
### ��������������Ĺ���
�����ڴ�ķ��䲻�Ǵ�default_pmm.c�п�ʼ�ģ�����ϵͳ����һ��ʼ����ڵ���ڹ滮ʵ�������ڴ�������������ӽű�kernel.ld�ж������һ������ַ���������ں���Ϊ�Լ����ڸߵ�ַ��enter.S��ɵ�������ǰ�Ԥ��Ķ���ҳ���λ�ý���satp�Ĵ�����ͨ��mmu�ķ�����뵽init.c��ִ���ں˳�ʼ����

��Ϊ�ں˳�ʼ����һ���֣�kern_init�����pmm_initִ�������ڴ��ʼ����pmm_init��ѡ��һ���㷨������Ĭ�ϵľ���first-fit�㷨����ҳ����ʼ������ҳ�����ٰѿ���Ȩ����page_init�����ʼ�������ڴ�ҳ�������豸�������������ڴ���Ϣ���Կ��õ������ڴ棬�������init_memmap���������������г�ʼ������������һ������ָ�룬��pmm_manager�ṹ���е�ָ�������ʹ��first�㷨����ζ��ָ��default_intit_memmap��������������Ͱѿ���Ȩ���������ҳ������㷨�ļ���

----------------------

dedault_pmm.c�����ڲ���Ҫ�ĺ����� `default_init`��`default_init_memmap`��`default_alloc_pages`��`default_free_pages` �ĸ�������˵�ĸ����������þ��ǳ�ʼ���������Լ��ͷ�ҳ��������������ϸ����һ�¸��������ľ������á�

### 1. ��ʼ���׶�

#### `default_init`
- ���ã���ʼ������ҳ���� `free_list`�������ܿ���ҳ�� `nr_free` ����Ϊ 0��
- ˵�������� First-Fit �㷨��׼��������Ϊ�����������ҳ��׼����

#### `default_init_memmap(struct Page *base, size_t n)`
- ���ã��� `[base, base+n)` ��Χ�ڵ���������ҳ���Ϊ�ɷ��䣬�������������
- ���������
  - ��ÿҳ��ʼ����
    - `ref = 0`����ʾ��ǰҳû�б����á�
    - `flags` �� `property` ���ڱ��ҳ��״̬�Ϳ��п��С��
  - �����п鰴�������ַ˳����� `free_list`��
  - �����ܿ���ҳ�� `nr_free += n`��

### 2. ����׶�

#### `default_alloc_pages(size_t n)`
- ���ã����� `n` ҳ�����ڴ档
- �������̣�
  1. ������������Ѱ�ҵ�һ������ `property >= n` �Ŀ��п顣
  2. �ҵ����
     - ��ǰ `n` ҳ������������� `PG_reserved = 1`��`PG_property = 0`��
     - ������п���� `n` ҳ����ʣ�ಿ�����±��Ϊ�µĿ��п鲢��������
  3. �����ܿ���ҳ�� `nr_free -= n`��
- ��������û���㹻��Ŀ飬�򷵻� `NULL`��

### 3. �ͷŽ׶�

#### `default_free_pages(struct Page *base, size_t n)`
- ���ã��ͷ� `n` ҳ�����ڴ棬�����������ڿ��п�ϲ���
- �������̣�
  1. ���ͷŵ�ҳ���²�������������ְ������ַ�������С�
  2. ���ҳΪ�ɷ��䣺
     - `ref = 0`
     - `PG_property = 1`�����ǿ��п���ʼҳ��
  3. ������ǰ����п�ϲ����γɸ�����������п顣
  4. �����ܿ���ҳ�� `nr_free += n`��

### 4. ��ѯ����ҳ��

#### `default_nr_free_pages`
- ���ã�ֱ�ӷ��ص�ǰ�ܿ���ҳ�� `nr_free`��

### 5.���ܲ���
#### `basic_check(void)` �� `default_check(void)`
- `basic_check(void)`�����ܲ��ԣ���֤ҳ�������ͷ��Ƿ�����
- `default_check(void)`�����First-Fit�����㷨���������ܼ��

### 6. First-Fit �㷨�ص���Ľ��ռ�
- **�ص�**��
  - ����ʵ�֣�ֱ�ӱ������������ҵ���һ������������Ŀ顣
  - �ʺ�С��ģ�ڴ����
- **�Ľ��ռ�**��
  1. **���������������**��ÿ�η��䶼Ҫ������ͷ����ʼɨ�裬ÿ�εķ��䶼�Ƿ��俿������ͷ�ģ���ᵼ�±���·����������ʹ�� Next-Fit�����ϴη���λ�ü��������������ٱ���������
  2. **�����ڴ���Ƭ**����Ȼfirst-fit����Ѹ���ҵ�һ������Ҫ��Ŀ飬���ǻᵼ�´����ڴ���Ƭ�������㷨��������ģ�ʹ�� Best-Fit ���� Buddy System��һ����Ҫ˼·��
  3. **�༶��������**�������п��С�ּ������ٶ�λ���ʿ飬��Ȼ��Ҫȥά��������������ܴ����ٷ�����ʱ��
  4. **�Ż��ϲ�����**���ӳٺϲ���ϲ������Ż��Լ����ͷŲ���������


## Best-Fit ʵ�ֹ���
Best-Fit ��Ҫ����������������ʵ�֣�
- best_fit_init_memmap
- best_fit_alloc_pages
- best_fit_free_pages

�ֱ�ʵ�ֿ�������ĳ�ʼ����ҳ�ķ��䣬ҳ���ͷ���ϲ����ܣ����潫��ϸ��ÿ������ʵ�ֽ���˵��

### 1.best_fit_init_memmap
���������Ҫʵ���˳�ʼ��ҳ�ı�־���ԣ������ڴ�ҳ�����ԣ��Լ���ҳ��������������λ�õĲ�����
���д�����ԭ����first_fit����һ�£������ҳ��ı�־�����ԣ���ҳ������ü�������Ϊ0��
```
p->flags = p->property = 0;
set_page_ref(p, 0);
```
���д�����ʵ���˶Կ�������Ĵ������ж����б�Ϊ�պ󣬲���best_fit����������base��
�����������������ַ���򣬰ѿ���뵽�����У��������������β����˵�� base ������ҳ�򣬽������뵽β�����������ע�Ͳ��ֵ�Ҫ�󣬱��ֺ�first_fit��ͬ�����߷�ʽ��ʹ�á�base < page��ֱ�ӱȽϵ��������ַ�Ĵ�С��Ҳ�������ڴ��ϵ��Ⱥ�˳���ڷ���Ĺ����У�����Ҫ������������ʱ�临�ӶȻ�Ƚϴ󣬵��ǣ�����������Ժϲ����Ѻá�������ʹ�����µĴ��룬�Ժ���ڸ�����ʹ����һ���Ż�������
```
if (base->property < page->property) {
   list_add_before(le, &(base->page_link));
   break;}
else if (list_next(le) == &free_list) {
list_add(le, &(base->page_link));
}
```

### 2.best_fit_alloc_pages
���������Ҫʵ��best-fit�㷨�ķ�����ԣ��ҵ������������С���п���з��䡣

first-fit�ҵ���һ������鼴ֹͣ������best-fit����������������ҵ���С����飬���break������������ͬ���ڱ��������У���¼��С����Ҫ��Ŀ��С�����ϸ��£�ֱ��������ȫ�õ�����Ҫ�����С�顣

```
while ((le = list_next(le)) != &free_list){
    struct Page *p = le2page(le, page_link);
    if (p->property >= n && p->property < min_size) {
        min_size = p->property;
        page = p;
    }
}
```

�ڵõ���С���������һ���µ����⣬�����Ŀ��ܻ���Բ�֣��������Ҫ��֣�����һ������ָ����һ�����׾Ϳ����ˣ��������Ҫ��֣���ô����Ҫ��ʣ�ಿ����Ȼ���������ַ����ķ�ʽ������Ӧλ�ã�������������ʱ����Ϊԭ���һ���֣�ʣ�ಿ�ֵ��׵�ַ��Ȼ��ԭ���ǰ������֮�䣬�����Ҫ���ľ��Ǽ���ʣ���Ĵ�С��ʣ��ҳĿ�Ĵ�С����ʣ�ಿ����Ȼ�ŵ�ԭ���ǰ���֮�䣬����������Ĵ���ʵ�֣�

```
if (page != NULL) {
    list_entry_t* prev = list_prev(&(page->page_link));
    list_del(&(page->page_link));
    if (page->property > n) {
        struct Page *p = page + n;
        p->property = page->property - n;
        SetPageProperty(p);
        list_add(prev, &(p->page_link));
    }
    nr_free -= n;
    ClearPageProperty(page);
}
```

### 3.best_fit_free_pages
���������Ҫ����ҳ����ͷţ�Ҳ���ǰѿ����½��뵽�����С���ʱ��������Ҫ�����ͷſ�����ԣ�������С�ͱ�ǣ�Ȼ���������ַ��˳�򣬰������뵽����ҳ��֮�У���ȥ����²���Ŀ飬�����������ַ˳������ģ���˵�һ���ҵ����������ַ��Ŀ���ʱ�����Ѿ��ҵ�������ͷſ��λ�ã�

```
if (list_empty(&free_list)) {
    list_add(&free_list, &(base->page_link));
} else {
    list_entry_t* le = &free_list;
    while ((le = list_next(le)) != &free_list) {
        struct Page* page = le2page(le, page_link);
        if (base < page) {
            list_add_before(le, &(base->page_link));
            break;
        } else if (list_next(le) == &free_list) {
            list_add(le, &(base->page_link));
        }
    }
}
```

������Ҫ��ɿ�ĺϲ�����ԭ��������û����Ҫ�ϲ��Ŀ��ʱ������ԭ��������Ҳ���ɾ������ɴη�����ͷŵõ��ģ������ѧ����Ҳ������ͬ�����ʣ���ֻ��Ҫ�����²�������Ŀ�ĺϲ����ɡ���Ϊ���������еĿ���������ַ����ģ�ֻ��Ҫ�����²���Ŀ���ǰ���ĺϲ����ɣ�������ھͺϲ���ʵ��������ܵĴ������£�

```
if (p + p->property == base) {
    p->property += base->property;
    ClearPageProperty(base);
    list_del(&(base->page_link));
    base = p;
}
```

### ���н��
���������Ĵ����޸ĺ�ʹ��make gradeָ��ִ�д��룬�õ����µ������
```
>>>>>>>>>> here_make>>>>>>>>>>>
gmake[1]: ����Ŀ¼��/home/cong/OS/labcode/lab2�� + cc kern/init/entry.S + cc kern/init/init.c + cc kern/libs/stdio.c + cc kern/debug/panic.c + cc kern/driver/console.c + cc kern/driver/dtb.c + cc kern/mm/best_fit_pmm.c + cc kern/mm/default_pmm.c + cc kern/mm/pmm.c + cc libs/printfmt.c + cc libs/readline.c + cc libs/sbi.c + cc libs/string.c + ld bin/kernel riscv64-unknown-elf-objcopy bin/kernel --strip-all -O binary bin/ucore.img gmake[1]: �뿪Ŀ¼��/home/cong/OS/labcode/lab2��
>>>>>>>>>> here_make>>>>>>>>>>>
<<<<<<<<<<<<<<< here_run_qemu <<<<<<<<<<<<<<<<<<
try to run qemu
qemu pid=5270
<<<<<<<<<<<<<<< here_run_check <<<<<<<<<<<<<<<<<<
  -check physical_memory_map_information:    OK
  -check_best_fit:                           OK
Total Score: 25/25
```
˵��˳��ʵ��best-fit���롣

### �㷨�ĸĽ�
#### ���տ��С����ʽ������
�ı�����������ԣ�ʹ�ÿ��С��С�������������ڷ����ڴ�ʱ���ҵ��ĵ�һ������Ҫ��Ŀ鼴��Ŀ��飬��Ӧ�ģ��ϲ��㷨����Ҫ����������룬���������������Ҫ���ĵ�lab2��exercise���벿�֣�

- part 1�����Ƚ�page��base�ĵ�ַ��С��Ϊ�Ƚ����ǵ�property���ԣ������ͷſ�Ĵ�С�ѿ�Żص�����֮�У�

```
if (base->property < page->property) {
    list_add_before(le, &(base->page_link));
    break;
}
```

- part 2���ڷ���ҳ��ʱ�������ĵ�һ������Ƿ���Ҫ��Ŀ飬����ֹͣ�������������Ҫ��ֵĿ飬ԭ����ַ����Ĵ���ֻ��Ҫ��ʣ�ಿ�ַŵ�ԭ�����λ�ü��ɣ�������Ҫ��������б����Ӷ��������ں��ʵ�λ�ã�

```
while ((le = list_next(le)) != &free_list) {
    struct Page *p = le2page(le, page_link);
    if (p->property >= n) {
        page = p;
        break;
    }
}

if (list_empty(&free_list)) {
    list_add(&free_list, &(p->page_link));
} else {
    list_entry_t* le = &free_list;
    while ((le = list_next(le)) != &free_list) {
        struct Page* page = le2page(le, page_link);
        if (p->property < page->property) {
            list_add_before(le, &(p->page_link));
            break;
        } else if (list_next(le) == &free_list) {
            list_add(le, &(p->page_link));
        }
    }
}
```

- part 3���ϲ�ʱ��ԭ���������ַ����ʽֻ��Ҫ�Կ��ǲ���������ڿ�ĺϲ����ܣ�������Ҫ������������ȥ�ҵ����������ٽ��������ַ�Ŀ飬���ж��Ƿ�������ǰ�����ϲ����ܣ�

```
while ((le = list_next(le)) != &free_list) {
    struct Page* candidate = le2page(le, page_link);
    if (candidate == base) continue;
    
    if (candidate + candidate->property == base) {
        candidate->property += base->property;
        ClearPageProperty(base);
        list_del(&(base->page_link));
        base = candidate;
        merged = true;
        break;
    }
    if (base + base->property == candidate) {
        base->property += candidate->property;
        ClearPageProperty(candidate);
        list_del(&(candidate->page_link));
        merged = true;
        break;
    }
}
```

#### ��һ���Ż�
����ע�⵽��ʹ�ÿ��������Ҫ�����ӷ���ʱ�ı�������˺ϲ�ʱ�ı�����������ǿ���ѡ����õĺϲ����ԣ����ӳٺϲ���ȥ������һ���ֵ�ƽ����ġ�

���⣬����ʹ�ö༶���������ÿһ���һ������ͷ����һ������ͷ�������п��С����1ҳ�Ŀ飬�ڶ�������ͷ�������п��С����2ҳ�Ŀ飬�Դ����ƣ��Կ��С�Ŀ����Լ�������֮�������Ϳ���һ��ʵ�ֿ�ķ������ͷţ������ٱ������������ġ�

## ��չ��ϰ
### Ӳ���Ŀ��������ڴ淶Χ�Ļ�ȡ����
�� ucore�У�����ϵͳ��ȡ���������ڴ�ķ�ʽ��ͨ������QEMU�ṩ��DTB��Device Tree Blob����DTB�а����ڴ���ʼ��ַ�ʹ�С��Ϣ���ں�����ʱ�������DTB��ʼ������ҳ�������������ڴ��������PMM����
���û��DTB��̼��ṩ��Ϣ������ϵͳ����ͨ����ҳ̽���ڴ���ȡ�ض�Ӳ���Ĵ����ķ�������ȡ�����ڴ淶Χ�������ַ�����ʵ�黷���в��Ƽ�����Ϊ���ܷ��ʷǷ���ַ����쳣��

## �ܽ�