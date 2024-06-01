/*
Name: Nadia Ferdoush
Date: 07/12/19
Copyright: © 2019, Nadia Ferdoush. All rights reserved.
*/

import 'package:flutter/material.dart';

class GroupedCheckbox extends StatefulWidget {
  /// A list of string that describes each checkbox. Each item must be distinct.
  final List<String>? itemList;

  /// A list of string which specifies automatically checked checkboxes.
  /// Every element must match an item from itemList.
  final List<String>? checkedItemList;

  /// A list of string which specifies automatically checked checkboxes.
  /// Every element must match an item from itemList.
  final List<String>? checkedItemNAmedSelectedList;

  /// Specifies which boxes should be disabled.
  /// If this is non-null, no boxes will be disabled.
  /// The strings passed to this must match the labels.
  final List<String>? disabled;

  /// The style to use for the labels.
  final TextStyle? textStyle;

  /// Specifies the orientation of the elements in itemList.
  final CheckboxOrientation? orientation;

  /// Called when the value of the checkbox group changes.
  final Function? onChanged;

  /// The color to use when this checkbox is checked.
  ///
  /// Defaults to [ThemeData.toggleableActiveColor].
  final Color? activeColor;

  /// The color to use for the check icon when this checkbox is checked.
  ///
  /// Defaults to Color(0xFFFFFFFF)
  final Color? checkColor;

  /// If true the checkbox's value can be true, false, or null.
  final bool? tristate;

  /// Configures the minimum size of the tap target.
  final MaterialTapTargetSize? materialTapTargetSize;

  /// The color for the checkbox's Material when it has the input focus.
  final Color? focusColor;

  /// The color for the checkbox's Material when a pointer is hovering over it.
  final Color? hoverColor;

  //.......................WRAP ORIENTATION.....................................

  /// The direction to use as the main axis.
  ///
  /// For example, if [wrapDirection] is [Axis.horizontal], the default, the
  /// children are placed adjacent to one another in a horizontal run until the
  /// available horizontal space is consumed, at which point a subsequent
  /// children are placed in a new run vertically adjacent to the previous run.
  final Axis wrapDirection;

  /// How the children within a run should be placed in the main axis.
  ///
  /// For example, if [wrapAlignment] is [WrapAlignment.center], the children in
  /// each run are grouped together in the center of their run in the main axis.
  ///
  /// Defaults to [WrapAlignment.start].
  ///
  /// See also:
  ///
  ///  * [wrapRunAlignment], which controls how the runs are placed relative to each
  ///    other in the cross axis.
  ///  * [wrapCrossAxisAlignment], which controls how the children within each run
  ///    are placed relative to each other in the cross axis.
  final WrapAlignment wrapAlignment;

  /// How much space to place between children in a run in the main axis.
  ///
  /// For example, if [wrapSpacing] is 10.0, the children will be spaced at least
  /// 10.0 logical pixels apart in the main axis.
  ///
  /// If there is additional free space in a run (e.g., because the wrap has a
  /// minimum size that is not filled or because some runs are longer than
  /// others), the additional free space will be allocated according to the
  /// [wrapAlignment].
  ///
  /// Defaults to 0.0.
  final double wrapSpacing;

  /// How the runs themselves should be placed in the cross axis.
  ///
  /// For example, if [wrapRunAlignment] is [WrapAlignment.center], the runs are
  /// grouped together in the center of the overall [Wrap] in the cross axis.
  ///
  /// Defaults to [WrapAlignment.start].
  ///
  /// See also:
  ///
  ///  * [wrapAlignment], which controls how the children within each run are placed
  ///    relative to each other in the main axis.
  ///  * [wrapCrossAxisAlignment], which controls how the children within each run
  ///    are placed relative to each other in the cross axis.
  final WrapAlignment wrapRunAlignment;

  /// How much space to place between the runs themselves in the cross axis.
  ///
  /// For example, if [wrapRunSpacing] is 10.0, the runs will be spaced at least
  /// 10.0 logical pixels apart in the cross axis.
  ///
  /// If there is additional free space in the overall [Wrap] (e.g., because
  /// the wrap has a minimum size that is not filled), the additional free space
  /// will be allocated according to the [wrapRunAlignment].
  ///
  /// Defaults to 0.0.
  final double wrapRunSpacing;

  /// How the children within a run should be aligned relative to each other in
  /// the cross axis.
  ///
  /// For example, if this is set to [WrapCrossAlignment.end], and the
  /// [wrapDirection] is [Axis.horizontal], then the children within each
  /// run will have their bottom edges aligned to the bottom edge of the run.
  ///
  /// Defaults to [WrapCrossAlignment.start].
  ///
  /// See also:
  ///
  ///  * [wrapAlignment], which controls how the children within each run are placed
  ///    relative to each other in the main axis.
  ///  * [wrapRunAlignment], which controls how the runs are placed relative to each
  ///    other in the cross axis.
  final WrapCrossAlignment wrapCrossAxisAlignment;

  /// Determines the order to lay children out horizontally and how to interpret
  /// `start` and `end` in the horizontal direction.
  ///
  /// Defaults to the ambient [Directionality].
  ///
  /// If the [wrapDirection] is [Axis.horizontal], this controls order in which the
  /// children are positioned (left-to-right or right-to-left), and the meaning
  /// of the [wrapAlignment] property's [WrapAlignment.start] and
  /// [WrapAlignment.end] values.
  ///
  /// If the [wrapDirection] is [Axis.horizontal], and either the
  /// [wrapAlignment] is either [WrapAlignment.start] or [WrapAlignment.end], or
  /// there's more than one child, then the [wrapTextDirection] (or the ambient
  /// [Directionality]) must not be null.
  ///
  /// If the [wrapDirection] is [Axis.vertical], this controls the order in which
  /// runs are positioned, the meaning of the [wrapRunAlignment] property's
  /// [WrapAlignment.start] and [WrapAlignment.end] values, as well as the
  /// [wrapCrossAxisAlignment] property's [WrapCrossAlignment.start] and
  /// [WrapCrossAlignment.end] values.
  ///
  /// If the [wrapDirection] is [Axis.vertical], and either the
  /// [wrapRunAlignment] is either [WrapAlignment.start] or [WrapAlignment.end], the
  /// [wrapCrossAxisAlignment] is either [WrapCrossAlignment.start] or
  /// [WrapCrossAlignment.end], or there's more than one child, then the
  /// [wrapTextDirection] (or the ambient [Directionality]) must not be null.
  final TextDirection? wrapTextDirection;

  /// Determines the order to lay children out vertically and how to interpret
  /// `start` and `end` in the vertical direction.
  ///
  /// If the [wrapDirection] is [Axis.vertical], this controls which order children
  /// are painted in (down or up), the meaning of the [wrapAlignment] property's
  /// [WrapAlignment.start] and [WrapAlignment.end] values.
  ///
  /// If the [wrapDirection] is [Axis.vertical], and either the [wrapAlignment]
  /// is either [WrapAlignment.start] or [WrapAlignment.end], or there's
  /// more than one child, then the [wrapVerticalDirection] must not be null.
  ///
  /// If the [wrapDirection] is [Axis.horizontal], this controls the order in which
  /// runs are positioned, the meaning of the [wrapRunAlignment] property's
  /// [WrapAlignment.start] and [WrapAlignment.end] values, as well as the
  /// [wrapCrossAxisAlignment] property's [WrapCrossAlignment.start] and
  /// [WrapCrossAlignment.end] values.
  ///
  /// If the [wrapDirection] is [Axis.horizontal], and either the
  /// [wrapRunAlignment] is either [WrapAlignment.start] or [WrapAlignment.end], the
  /// [wrapCrossAxisAlignment] is either [WrapCrossAlignment.start] or
  /// [WrapCrossAlignment.end], or there's more than one child, then the
  /// [wrapVerticalDirection] must not be null.
  final VerticalDirection wrapVerticalDirection;

  String? filter;
  List? countryName;
  List? countryShortName;
  List<String>? listCheckedName;
  bool? isVisible;

  GroupedCheckbox({
    required this.itemList,
    required this.orientation,
    required this.onChanged,
    this.checkedItemList,
    this.listCheckedName,
    this.isVisible,
    this.textStyle = const TextStyle(),
    this.disabled,
    this.activeColor,
    this.checkedItemNAmedSelectedList,
    this.checkColor,
    this.focusColor,
    this.filter,
    this.countryName,
    this.countryShortName,
    this.hoverColor,
    this.materialTapTargetSize,
    this.tristate = false,
    this.wrapDirection = Axis.horizontal,
    this.wrapAlignment = WrapAlignment.start,
    this.wrapSpacing = 0.0,
    this.wrapRunAlignment = WrapAlignment.start,
    this.wrapRunSpacing = 0.0,
    this.wrapCrossAxisAlignment = WrapCrossAlignment.start,
    this.wrapTextDirection,
    this.wrapVerticalDirection = VerticalDirection.down,
  });

  @override
  _GroupedCheckboxState createState() => _GroupedCheckboxState();
}

class _GroupedCheckboxState extends State<GroupedCheckbox> {
  List<String> selectedListItems = <String>[];
  List<String> selectedNamedListItems = <String>[];

  @override
  Widget build(BuildContext context) {
    Widget finalWidget = generateItems();
    return ListView.builder(
        itemCount: widget.countryName!.length,
        itemBuilder: (context, index) {
          return widget.filter == null || widget.filter == ""
              ? item(index)
              : widget.countryName![index]
                      .toLowerCase()
                      .contains(widget.filter!.toLowerCase())
                  ? item(index)
                  : Container();
        });

    //مص
  }

  Widget generateItems() {
    List<Widget> content = [];
    Widget finalWidget;
    if (widget.checkedItemList != null) {
      selectedListItems = widget.checkedItemList ?? [];
      selectedNamedListItems = widget.listCheckedName ?? <String>[];
    }
    List<Widget> widgetList = <Widget>[];
    for (int i = 0; i < widget.itemList!.length; i++) {
      widgetList.add(item(i));
    }
    if (widget.orientation == CheckboxOrientation.VERTICAL) {
      for (final item in widgetList) {
        content.add(Row(children: <Widget>[item]));
      }
      finalWidget = SingleChildScrollView(
          scrollDirection: Axis.vertical, child: Column(children: content));
    } else if (widget.orientation == CheckboxOrientation.HORIZONTAL) {
      for (final item in widgetList) {
        content.add(Column(children: <Widget>[item]));
      }
      finalWidget = SingleChildScrollView(
          scrollDirection: Axis.horizontal, child: Row(children: content));
    } else {
      finalWidget = SingleChildScrollView(
        child: Wrap(
            children: widgetList,
            spacing: widget.wrapSpacing,
            runSpacing: widget.wrapRunSpacing,
            textDirection: widget.wrapTextDirection,
            crossAxisAlignment: widget.wrapCrossAxisAlignment,
            verticalDirection: widget.wrapVerticalDirection,
            alignment: widget.wrapAlignment,
            direction: Axis.horizontal,
            runAlignment: widget.wrapRunAlignment),
      );
    }
    return finalWidget;
  }

  Widget item(int index) {
    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          margin: EdgeInsets.all(8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(color: Colors.grey[300]),
                child: Theme(
                  data: ThemeData(unselectedWidgetColor: Colors.grey[300]),
                  child: Checkbox(
                      activeColor: widget.activeColor,
                      checkColor: widget.checkColor,
                      focusColor: widget.focusColor,
                      hoverColor: widget.hoverColor,
                      materialTapTargetSize: widget.materialTapTargetSize,
                      value:
                          selectedListItems.contains(widget.itemList![index]),
                      tristate: widget.tristate!,
                      onChanged: (widget.disabled != null &&
                              widget.disabled!
                                  .contains(widget.itemList!.elementAt(index)))
                          ? null
                          : (bool? selected) {
                              onChanged(selected ?? false, index);
                            }),
                ),
              ),
              SizedBox(width: 15),
              Row(children: [
                Visibility(
                  visible: widget.isVisible ?? false,
                  child: Container(
                    width: 36,
                    height: 26,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        image: DecorationImage(
                            image: ExactAssetImage(
                                'assets/images/flags/${widget.countryShortName![index]}.png'),
                            fit: BoxFit.cover)),
                  ),
                ),
                SizedBox(width: 6),
                Text(
                  widget.countryName![index],
                )
              ])
            ],
          ),
        );
      },
    );
  }

  onChanged(bool selected, index) {
    setState(() {
      print('item clicked ${widget.itemList![index]}');
      print('item clicked ${widget.itemList![index].runtimeType}');

      if (widget.itemList![index] != '0' || widget.itemList![index] != '-1') {
        selectedListItems.remove('0');
        selectedListItems.remove('-1');
        selectedNamedListItems.remove('الكل');
      }

      selected
          ? selectedListItems.add(widget.itemList![index])
          : selectedListItems.remove(widget.itemList![index]);
      selected
          ? selectedNamedListItems.add(widget.countryName![index])
          : selectedNamedListItems.remove(widget.countryName![index]);

      print("List Name Checked: ${widget.listCheckedName}");
      print("List Id Checked: $selectedListItems");

      if (widget.itemList![index] == '0' || widget.itemList![index] == '-1') {
        selectedListItems.clear();
        selectedListItems.add('0');
        selectedListItems.add('-1');
        selectedNamedListItems.clear();
        selectedNamedListItems.add('الكل');
      }

      setState(() {
        widget.onChanged!(selectedListItems, selectedNamedListItems);
      });
    });
  }
}

enum CheckboxOrientation { HORIZONTAL, VERTICAL, WRAP }
