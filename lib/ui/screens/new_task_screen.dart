import 'package:flutter/material.dart';
import 'package:task_manager_app/data/models/task_count.dart';

import 'package:task_manager_app/data/models/task_count_summary_list_model.dart';
import 'package:task_manager_app/data/models/task_list_model.dart';
import 'package:task_manager_app/data/network_caller/network_caller.dart';
import 'package:task_manager_app/data/network_caller/network_response.dart';
import 'package:task_manager_app/data/utility/urls.dart';
import 'package:task_manager_app/ui/screens/add_new_tasks_screen.dart';

import '../../widget/profile_summary_card.dart';
import '../../widget/summary_card.dart';
import '../../widget/task_item_card.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  bool getNewTaskInProgress = false;
  bool getTaskCountSummaryInProgress = false;
  TaskListModel taskListModel = TaskListModel();
  TaskCountSummaryListModel taskCountSummaryListModel =
      TaskCountSummaryListModel();
  Future<void> getTaskCountSummaryList() async {
    getTaskCountSummaryInProgress = true;

    if (mounted) {
      setState(() {});
    }
    final NetworkResponse response =
        await NetworkCaller().getRequest(Urls.getTaskStatusCount);
    if (response.isSuccess) {
      taskCountSummaryListModel =
          TaskCountSummaryListModel.fromJson(response.jsonResponse);
    }
    getTaskCountSummaryInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> getNewTaskList() async {
    getNewTaskInProgress = true;
    if (mounted) {
      setState(() {});
    }
    final NetworkResponse response =
        await NetworkCaller().getRequest(Urls.getNewTasks);
    if (response.isSuccess) {
      taskListModel = TaskListModel.fromJson(response.jsonResponse);
    }
    getNewTaskInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    getTaskCountSummaryList();
    getNewTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AddNewTaskScreen()));
          },
          child: const Icon(Icons.add),
        ),
        body: SafeArea(
          child: Column(
            children: [
              const ProfileSummaryCard(),
              Visibility(
                visible: getTaskCountSummaryInProgress == false &&
                    (taskCountSummaryListModel.taskCountList?.isNotEmpty ??
                        false),
                replacement: const LinearProgressIndicator(),
                child: SizedBox(
                  height: 120,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount:
                          taskCountSummaryListModel.taskCountList?.length ?? 0,
                      itemBuilder: (context, index) {
                        TaskCount taskCount =
                            taskCountSummaryListModel.taskCountList![index];
                        return FittedBox(
                          child: SummaryCard(
                            count: taskCount.sum.toString(),
                            title: taskCount.sId ?? '',
                          ),
                        );
                      }),
                ),
              ),
              Expanded(
                  child: Visibility(
                visible: getNewTaskInProgress == false,
                replacement: const Center(
                  child: CircularProgressIndicator(),
                ),
                child: RefreshIndicator(
                  onRefresh: getNewTaskList,
                  child: ListView.builder(
                      itemCount: taskListModel.taskList?.length ?? 0,
                      itemBuilder: (context, index) {
                        return TaskItemCard(
                          task: taskListModel.taskList![index],
                          onStatusChange: () {
                            getNewTaskList();
                          },
                          showProgress: (inProgress) {
                            getNewTaskInProgress = inProgress;
                            if (mounted) {
                              setState(() {});
                            }
                          },
                        );
                      }),
                ),
              ))
            ],
          ),
        ));
  }
}
