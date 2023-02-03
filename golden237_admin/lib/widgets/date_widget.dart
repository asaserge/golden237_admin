import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../messages/constants.dart';

class DateWidget extends StatefulWidget {
  const DateWidget({Key? key}) : super(key: key);

  @override
  State<DateWidget> createState() => _DateWidgetState();
}

class _DateWidgetState extends State<DateWidget> {

  late TextEditingController startDate;
  late TextEditingController endDate;

  @override
  void initState() {
    startDate = TextEditingController();
    endDate = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    startDate.dispose();
    endDate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: startDate,
            readOnly: true,
            validator: (startDate){
              if(startDate==null|| startDate.isEmpty){
                return "Please Input Start Date";
              }
              else {
                return null;
              }
            },
            decoration: InputDecoration(
              hintText: 'Start Date',
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(
                      width: 1,
                      color: primaryColor
                  )
              ),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(
                      width: 1,
                      color: Colors.white38
                  )
              )
            ),
            onTap: () async{
              DateTime? startPickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100)
              );
              if(startPickedDate!= null){
                String formattedDate = DateFormat('dd-MM-yyyy').format(startPickedDate);
                setState(() {
                  startDate.text = formattedDate; //set output date to TextField value.
                });
              }
            },
          ),
        ),

        const SizedBox(width: 15.0),

        Expanded(
          child: TextFormField(
            controller: endDate,
            readOnly: true,
            validator: (endDate){
              if(endDate==null || endDate.isEmpty){
                return "Please Input End Date";
              }else {
                return null;
              }
            },
            decoration: InputDecoration(
                hintText: 'End Date',
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(
                        width: 1,
                        color: primaryColor
                    )
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(
                        width: 1,
                        color: Colors.white38
                    )
                )
            ),
            onTap: () async{
              if (startDate.text.isNotEmpty) {
                String dateTime = startDate.text;
                DateFormat inputFormat = DateFormat('dd-MM-yyyy');
                DateTime input = inputFormat.parse(dateTime);

                DateTime? endPickedDate = await showDatePicker(
                  context: context,
                  initialDate: input.add(const Duration(days: 1)),
                  firstDate:  input.add(const Duration(days: 1)),
                  lastDate: DateTime.now().add(const Duration(days: 186))
                );
                if(endPickedDate!= null){
                  String formattedDate = DateFormat('dd-MM-yyyy').format(endPickedDate);
                  setState(() {
                    endDate.text = formattedDate;
                  }
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('You need to select Start Date first!'),
                      backgroundColor: Colors.red,
                    )
                );
              }
            },
          )
        ),
      ],
    );
  }
}