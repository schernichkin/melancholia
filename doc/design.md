# Шедулер

## Граф задач

Граф задач представляет собой DAG (если есть циклы, они должны быть слиты в один
узел, возможно в будущем можно будет сделать специальный тип составной задачи,
которая планируется как одна задача, но может работать на разных узлах). Ребра
в графе указывают направление отправки сообщений.

## Полное планирование

Шедулер работает инкрементально (т.к. в процессе работы могут уточняться
параметры задач), но на каждом шаге должен строить полный план исполнения.
Если все потоковые задачи помещаются в имеющиеся ресурсы, задача элементарна:
надо просто разместить задачи на узлах с минимальной стоимостью (однако даже
в этом случае может быть выгоднее разбить задачу и перепланировать исполнение).
Если ресурсов для выполнения всех задач одновременно недостаточно, необходимо
разбить граф задач на завершимые подграфы (возможно, посредством установки
искуственных spill-каналов), и запланировать их выоплнение так, чтобы итоговое
время выполнения было минимальным.

## Завершимый подграф

Для того, чтобы завершиться, задача должна принять все сообщения от источников и
отправить их всем своим подписчикам. Для этого:

- Все её источники должны быть "завершимими" (иначе они могут быть блокированы
  механизмами back pressure).
- Все её выходные каналы должны быть либо подключены к завершимым задачам, либо
  к буферизируемым (которые могут принять все входные сообщения).

## Выделение завершимых подграфов

Для обнаружения завершимого подграфа достаточно обойти DAG, начиная с источника.
Вообще, общий граф задачи всегда завершим, но из него можно попробовать выделить
завершимые подграфы меньших размеров, обходя их из каждого источника и выкидывая
рёбра, готовые принять все сообщения. Сами по себе завершимые подграфы образуют
DAG. Все задачи в завершимом подграфе завершаются примерно в одно время (но
это не строго обязательно). Таким образом DAG-и завершимых подграфов могут
шедулится по принципу bin packing.

## Общая схема

Выделение завершимых подграфов, анализ и разбиение завершимых подграфов, если
они не могут быть зашедулены в исходном виде. Построение DAG -а завершимых
подграфов и шедулинг задач каждого из этих DAG-ов.

Основная проблема тут будет не с шедулингом DAG-а завершимых подграфов, а с
оптимальным разбиенимем задачу на подзадачи, которые будут "помещаться" в
ресурсы кластера.

## Перепланирование вычисления
