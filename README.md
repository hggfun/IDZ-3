# ИДЗ 3

Зиганшин Алим, БПИ216, Вариант 24

Ожидаемая оценка 8.

Условие:

*Разработать программу, вычисляющую с помощью ряда Эйлера с*

*точностью не хуже 0,1% значение числа e.*

Теоретическая часть решения:

Имея ряд Эйлера, можем вывести формулу, для подсчета числа <img src="https://latex.codecogs.com/svg.latex?\Large&space;e=\sum_{i=0}^{\infty}\frac{1}{i!}" title="\Large \sum_{i=0}^{\infty}\frac{1}{i!}" />

При подсчете с определенной точностью бесконечность можно заменить на некоторое натуральное n. Дальнейшее решение будет опираться на эту формулу.

### 1. Решение на С:

Два файла: main.c и func.c

Первый получает аргументы из командной строки, считывает из файла/консоли входной параметр n (точность вычисления):

```c
//main.c
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

FILE *file1;
FILE *file2;

extern double antifactorial();

int main(int argc, char **argv) {
    time_t start, finish;
    start = time(NULL);
    int n;
    if (argc == 3) {
        file1 = fopen(*(argv+1), "r");
        n = fgetc(file1) - '0';
    } else {
        scanf("%d", &n);
    }
    if (n == 0) {
        n = rand()%7 + 6;
    }
    if (n < 6) {
        n = 6;
    } else if (n > 12) {
        n = 12;
    }
    double res = 0;
    for (int i = 0; i < n; ++i) {
        res += antifactorial(i);
    }
    finish = time(NULL);
    if (argc == 3) {
        file2 = fopen(*(argv+2), "w");
        fprintf(file2, "%.8f\n", res);
        fprintf(file2, "Time: %.1f", difftime(finish, start));
    } else {
        printf("%.8f\n", res);
        printf("Time: %.1f", difftime(finish, start));
    }
    return 0;
}
```

Второй считает 1/n! (1 делить на н факториал) и возвращает его значение:

```c
//func.c
double antifactorial(int n) {
    int mul = 1;
    for (int i = 1; i <= n; ++i) {
        mul *= i;
    }
    double d = 1;
    double res = d / mul;
    return res;
}
```

### 2. Компиляция и проверка работы:

Компилируем с флагами, избавляясь от лишних макросов

Получаем две единицы компиляции: main.s и func.s

![Снимок экрана (200).png](https://github.com/hggfun/IDZ-3/blob/main/%D0%A1%D0%BD%D0%B8%D0%BC%D0%BE%D0%BA%20%D1%8D%D0%BA%D1%80%D0%B0%D0%BD%D0%B0%20(200).png)

Тут же проводим “первый пуск” с тестовым значением, и получаем корректный результат, погрешность присутствует, но в пределах условий.

### 3. Оптимизация за счет использования регистров процессора:

Часто используемы значения со стека кладем в свободные регистры процессора:

в main.s:

-40[rbp] ⇒ r12d

-24[rbp] ⇒ r13

-36[rbp] ⇒ r14d

в func.s:

-24[rbp] ⇒ r15d

Некторые с индексом d, поскольку необходимо 4 бита, а не 8

Также была произведена вручную оптимизация некоторых моментов, наприме

```nasm
//Было
mov	edi, 0
//Стало
xor edi, edi
```

```nasm
//Было
mov	eax, DWORD PTR -36[rbp]
mov	edi, eax
//Стало
mov edi, r14d
```

```nasm
//Было
mov	eax, DWORD PTR -40[rbp]
cmp	DWORD PTR -36[rbp], eax
//Стало
cmp r12d, r14d
```

Все остальное находится в исходном коде и прокомментировано.

### 4. Замеры времени и рандом:

1. Пользователю предоставляется возможность ввести параметр и из командной строки (в таком случае нажно будет ввести названия файлов для ввода и вывода)
2. Если в командной строке не окажется данных (т.е. пользователь отказался от ввода данных через файл), он сможет ввести их через консольный ввод. Если ввод окажется некорректным, программа нормирует его, подобрав соответствующее корректное значение ввода.
3. Также ему предоставляется возможность выбрать рандомное значение ввода, для этого в консоль (или в файл ввода) должно быть введено число 0. Программа автоматически сгенерирует значение, входящее в допустимый диапазон.

Что касается замер времени работы программы, то для этого использовался цикл (в сто миллионов проходов, вместо одного, который реально нужен) в части, которая и производила вычисления. В момент начала и конца программы бралось время, а затем выводилась разница этих значений:

```c
...
start = time(NULL);
...
...
for (int j = 0; j < 100000000; ++j) {
        res = 0;
        for (int i = 0; i < n; ++i) {
            res += antifactorial(i);
        }
    }
...
...
finish = time(NULL)
printf("%f", difftime(finish, start)
```

При вводе минимального значения для корректной точности (т.е. n = 6) я получил длительность в 4 секунды

Далее при вводе большего значения  (т.е. n = 9) я получил длительность в 8 секунд

### 5. Тестовое покрытие:

Поскольку в моей задаче изначально не было необходимости что-либо вводить, я, по рекомендации лектора, ввел дополнительный параметр, обозначающий точность вычислений.

При этом каждое следующее увеличение точности, задействует значительно больше ресурсов (дополнительный цикл подсчета факториала, который с каждым шагом еще и увеличивается).

Далее рассмотрим тестовые значения, их файлы для ввода и вывода можно найти в приложенной папке tests

Напомню, что при вводе 0, в n передается случайное значение от 6 до 12, при вводе других чисел <6, в n передается 6, а при вводе чисел >12, в n передается 12

| Input | Output |
| --- | --- |
| 1 | 2.71666667 |
| 6 | 2.71666667 |
| 8 | 2.71825397 |
| 10 | 2.71828153 |
| 12 | 2.71828183 |
| 100 | 2.71828183 |

Видно, как приближается значение, к значение е. Если с минимальной точнойстью разница около 0.00161515, то с максимальной точностью уже меньше чем 0.00000001.

### 6. Вручную отредактированная программа на ассемблере

Пункт в некоторой степени повторяет 3, но тут я покажу, что этот код работает также, как и код на си, сам код с комментариями:

(от использования вместо -40 позиции стека регистров процессора пришлось отказать в последний момент, т.к. в ходе кода имеется проверка адреса при сканф, и, кажется, такое нельзя сделать с регистрами)

```nasm
.file	"main.c"
	.intel_syntax noprefix
	.text
	.comm	file1,8,8
	.comm	file2,8,8
	.section	.rodata
.LC0:					#Формат работы с файлом чтение
	.string	"r"
.LC1:					#Формат переменной целое число
	.string	"%d"
.LC3:					#Формат работы с файлом запись
	.string	"w"
.LC4:					#Формат переменной с плавающей запятой,
	.string	"%.8f\n"	#С выводом 8 знаков после запятой
.LC5:					#Строка используемая для вывода 
	.string	"Time: %.1f"
	.text
	.globl	main
	.type	main, @function
main:					#Начало main
	push	rbp
	mov	rbp, rsp
	sub	rsp, 64		#Выравнивание стека
	mov	DWORD PTR -52[rbp], edi	#argc
	mov	QWORD PTR -64[rbp], rsi	#argv
	mov	rax, QWORD PTR fs:40
	mov	QWORD PTR -8[rbp], rax
	xor	eax, eax		#eax = 0
	xor	edi, edi		#edi = 0
	call	time			#Вызов time
	mov	r13, rax		
	cmp	DWORD PTR -52[rbp], 3	#if(argc == 3)
	jne	.L2
	mov	rax, QWORD PTR -64[rbp]#Заносим в rax первый входной
	add	rax, 8			#параметр командной строки
	mov	rax, QWORD PTR [rax]
	lea	rsi, .LC0[rip]		#Передаем параметр "чтение"
	mov	rdi, rax
	call	fopen
	mov	QWORD PTR file1[rip], rax	#
	mov	rax, QWORD PTR file1[rip]	#
	mov	rdi, rax			#Считываем из файла число
	call	fgetc				#и кладем в DWORD PTR -40[rbp] т.е. n
	sub	eax, 48			#(уменьшаем на 48, т.к. код 
	mov	DWORD PTR -40[rbp], eax			#числа на 48 больше числа)
	jmp	.L3
.L2:
	lea	rax, -40[rbp]
	mov	rsi, rax
	lea	rdi, .LC1[rip]
	mov	eax, 0
	call	__isoc99_scanf		#Вызов функции
.L3:					#Весь L3 занимается созданием условно
					#случайной переменной
	mov	eax, DWORD PTR -40[rbp]
	test	eax, eax
	jne	.L4
	call	rand
	movsx	rdx, eax
	imul	rdx, rdx, -1840700269
	shr	rdx, 32
	add	edx, eax
	mov	ecx, edx
	sar	ecx, 2
	cdq
	sub	ecx, edx
	mov	edx, ecx
	mov	ecx, edx
	sal	ecx, 3
	sub	ecx, edx
	sub	eax, ecx
	mov	edx, eax
	lea	eax, 6[rdx]
	mov	DWORD PTR -40[rbp], eax
.L4:
	mov	eax, DWORD PTR -40[rbp]
	cmp	eax, 5
	jg	.L5
	mov	DWORD PTR -40[rbp], 6
	jmp	.L6
.L5:
	mov	eax, DWORD PTR -40[rbp]		#eax = n (из С кода)
	cmp	eax, 12
	jle	.L6
	mov	DWORD PTR -40[rbp], 12		#if(n > 12) => n = 12
.L6:
	pxor	xmm0, xmm0
	movsd	QWORD PTR -32[rbp], xmm0
	mov	r14d, 0
	jmp	.L7
.L8:
	mov	edi, r14d
	mov	eax, 0
	call	antifactorial		#Вызов метода из второго файла
	movsd	xmm1, QWORD PTR -32[rbp]
	addsd	xmm0, xmm1
	movsd	QWORD PTR -32[rbp], xmm0
	add	r14d, 1		#i++
.L7:
	cmp	r14d, DWORD PTR -40[rbp]		#if(i < n)
	jl	.L8
	mov	edi, 0
	call	time
	mov	QWORD PTR -16[rbp], rax
	cmp	DWORD PTR -52[rbp], 3
	jne	.L9
	mov	rax, QWORD PTR -64[rbp]
	add	rax, 16
	mov	rdi, QWORD PTR [rax]
	lea	rsi, .LC3[rip]
	call	fopen
	mov	QWORD PTR file2[rip], rax
	mov	rax, QWORD PTR file2[rip]
	mov	rdx, QWORD PTR -32[rbp]
	movq	xmm0, rdx
	lea	rsi, .LC4[rip]
	mov	rdi, rax
	mov	eax, 1
	call	fprintf		#Вызов функции printf
	mov	rsi, r13
	mov	rdi, QWORD PTR -16[rbp]
	call	difftime		#Вызов функции difftime
	mov	rdi, QWORD PTR file2[rip]
	lea	rsi, .LC5[rip]
	mov	eax, 1
	call	fprintf
	jmp	.L10
.L9:
	mov	rax, QWORD PTR -32[rbp]
	movq	xmm0, rax
	lea	rdi, .LC4[rip]
	mov	eax, 1
	call	printf			#Вызов функции printf
	mov	rsi, r13
	mov	rdi, QWORD PTR -16[rbp]
	call	difftime		#Вызов функции difftime
	lea	rdi, .LC5[rip]
	mov	eax, 1
	call	printf			#Вызов функции printf
.L10:
	mov	eax, 0
	mov	rsi, QWORD PTR -8[rbp]
	xor	rsi, QWORD PTR fs:40
	je	.L12
	call	__stack_chk_fail@PLT
.L12:
	leave
	ret
	.size	main, .-main
	.ident	"GCC: (Ubuntu 9.4.0-1ubuntu1~20.04.1) 9.4.0"
	.section	.note.GNU-stack,"",@progbits
```

```nasm
.file	"func.c"
	.intel_syntax noprefix
	.text
	.globl	antifactorial
	.type	antifactorial, @function
antifactorial:					#Увы в регистрах не осталось места,
						#поэтому почти везде работа со стеком
	push	rbp
	mov	rbp, rsp
	mov	DWORD PTR -36[rbp], edi	#Выравнивание стека
	mov	r15d, 1			#mul = 1
	mov	DWORD PTR -20[rbp], 1		#i = 1
	jmp	.L2
.L3:
	imul	r15d, DWORD PTR -20[rbp]	#Умножение со знаком
	add	DWORD PTR -20[rbp], 1
.L2:
	mov	eax, DWORD PTR -20[rbp]
	cmp	eax, DWORD PTR -36[rbp]
	jle	.L3
	movsd	xmm0, QWORD PTR .LC0[rip]
	movsd	QWORD PTR -16[rbp], xmm0
	cvtsi2sd	xmm1, r15d
	movsd	xmm0, QWORD PTR -16[rbp]
	divsd	xmm0, xmm1
	movsd	QWORD PTR -8[rbp], xmm0
	movsd	xmm0, QWORD PTR -8[rbp]
	pop	rbp
	ret
	.size	antifactorial, .-antifactorial
	.section	.rodata
	.align 8
.LC0:
	.long	0
	.long	1072693248
	.ident	"GCC: (Ubuntu 9.4.0-1ubuntu1~20.04.1) 9.4.0"
	.section	.note.GNU-stack,"",@progbits
```

Ну и тут я конечно же провел еще раз все тестовые файлы и убедился, что все отлично работает.
