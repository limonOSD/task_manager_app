import 'package:flutter/material.dart';
import 'package:task_manager_app/data/models/task_list_model.dart';
import 'package:task_manager_app/data/network_caller/network_caller.dart';
import 'package:task_manager_app/data/network_caller/network_response.dart';
import 'package:task_manager_app/data/utility/urls.dart';
import 'package:task_manager_app/widget/profile_summary_card.dart';
import 'package:task_manager_app/widget/task_item_card.dart';

class CancelledTasksScreen extends StatefulWidget {
  const CancelledTasksScreen({super.key});

  @override
  State<CancelledTasksScreen> createState() => _CancelledTasksScreenState();
}

class _CancelledTasksScreenState extends State<CancelledTasksScreen> {
  bool getCancelledTaskInProgress = false;
  TaskListModel taskListModel = TaskListModel();

  Future<void> getProgressTaskList() async {
    getCancelledTaskInProgress = true;
    if (mounted) {
      setState(() {});
    }
    final NetworkResponse response =
        await NetworkCaller().getRequest(Urls.getCancelledTasks);
    if (response.isSuccess) {
      taskListModel = TaskListModel.fromJson(response.jsonResponse);
    } else {
      debugPrint(response.statusCode.toString());
    }
    getCancelledTaskInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    getProgressTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const ProfileSummaryCard(),
            Expanded(
              child: Visibility(
                visible: getCancelledTaskInProgress == false,
                replacement: const Center(
                  child: CircularProgressIndicator(
                    color: Colors.green,
                  ),
                ),
                child: RefreshIndicator(
                  onRefresh: getProgressTaskList,
                  child: ListView.builder(
                      itemCount: taskListModel.taskList?.length ?? 0,
                      itemBuilder: (context, index) {
                        return TaskItemCard(
                          task: taskListModel.taskList![index],
                          onStatusChange: () {
                            getProgressTaskList();
                          },
                          showProgress: (inProgress) {
                            getCancelledTaskInProgress = inProgress;
                            if (mounted) {
                              setState(() {});
                            }
                          },
                        );
                      }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
