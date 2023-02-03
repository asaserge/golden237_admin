import 'package:flutter/material.dart';

class SearchbarScreen extends StatefulWidget {
  const SearchbarScreen({Key? key}) : super(key: key);

  @override
  State<SearchbarScreen> createState() => _SearchbarScreenState();
}

class _SearchbarScreenState extends State<SearchbarScreen> {

  late TextEditingController _searchController;
  int textLength = 0;
  String enteredText = '';
  late ListView _listView;

  @override
  void initState() {
    _searchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          maxLines: 1,
          maxLength: 15,
          controller: _searchController,
          cursorColor: Colors.white,
          onChanged: (val){
            setState(() {
              textLength = val.length;
              enteredText = val;
            });
          },
          decoration: InputDecoration(
            counterText: '',
            hintText: 'Search products...',
            prefixIcon: const Icon(Icons.mic_outlined, color: Colors.white),
            suffixIcon: textLength > 0 ?
              InkWell(
                onTap: (){
                  setState(() {
                    _searchController.clear();
                    textLength = 0;
                  });
                },
                child: const Icon(Icons.cancel_outlined, color: Colors.white)) : null,
            border: const OutlineInputBorder(
              borderSide: BorderSide.none
            )
          ),

        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: textLength >= 3 ?
        ListView.builder(
            shrinkWrap: true,
            itemCount: 3,
            itemBuilder: (context, index){
              return Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.search_outlined),
                    title: Text('Black Jean Pant'),
                    onTap: (){

                    },
                  ),
                  Divider()
                ],
              );
            }
        ) : null,
      ),
    );
  }

  ///\////////////////Search/////////////

  searchEnteredText(String searchText){
    List<String> caseSearchList = [];
    String temp = "";
    for (int i = 0; i < searchText.length; i++) {
      temp = temp + searchText[i];
      caseSearchList.add(temp);
    }

    // List<DocumentSnapshot> documentList = (await Firestore.instance
    //     .collection("cases")
    //     .document(await firestoreProvider.getUid())
    //     .collection(caseCategory)
    //     .where("caseNumber", arrayContains: query)
    //     .getDocuments())
    // .documents;
    //
    // return documentList;
  }

}
