import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:test_photo_edit/screen/details_screen.dart';

import '../api/api_service.dart';
import '../model/data_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Meme> dataList = [];

  bool isLoading = true;

  @override
  void initState() async {
    // TODO: implement didChangeDependencies
    super.initState();
    dataList = await ApiHttpService().getDataList();
    setState(() {
      isLoading = false;
    });
  }
  String search = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("data"),
        ),
        body: ModalProgressHUD(
          progressIndicator: const CircularProgressIndicator(),
          inAsyncCall: isLoading,
          child: Container(
          padding: const EdgeInsets.all(16),
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              SizedBox(
                // height: 50,
                child: TextFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(color: Colors.green),
                      ),
                      hintText: "Input Search keyword"
                  ),
                  onChanged: (value) {
                    setState(() {
                      search = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 10,),
              Expanded(
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    if (dataList[index].name.toLowerCase().contains(search)) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => DetailsScreen(meme: dataList[index]),));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey.shade300
                          ),
                          child: Column(
                            children: [
                              Image(image: NetworkImage("${dataList[index].url}"),height: 200,width: 200,fit: BoxFit.cover,),
                              Text(
                                "${dataList[index].name}",
                                style: const TextStyle(color: Colors.black, fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    return Container();
                  },
                  itemCount: dataList.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(
                      height: 15,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        )
    );
  }
}
