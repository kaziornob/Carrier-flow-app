import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/job_provider.dart';

class JobSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onSearch;

  const JobSearchBar({
    super.key,
    required this.controller,
    required this.onSearch,
  });

  @override
  State<JobSearchBar> createState() => _JobSearchBarState();
}

class _JobSearchBarState extends State<JobSearchBar> {
  final FocusNode _focusNode = FocusNode();
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _showSuggestions = _focusNode.hasFocus;
    });
    
    if (!_focusNode.hasFocus) {
      Provider.of<JobProvider>(context, listen: false).clearSuggestions();
    }
  }

  void _onTextChanged(String value) {
    if (value.isNotEmpty) {
      Provider.of<JobProvider>(context, listen: false).getSuggestions(value);
    } else {
      Provider.of<JobProvider>(context, listen: false).clearSuggestions();
    }
  }

  void _onSuggestionTap(String suggestion) {
    widget.controller.text = suggestion;
    _focusNode.unfocus();
    widget.onSearch(suggestion);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: widget.controller,
          focusNode: _focusNode,
          onChanged: _onTextChanged,
          onSubmitted: widget.onSearch,
          decoration: InputDecoration(
            hintText: 'Search jobs, companies, skills...',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: widget.controller.text.isNotEmpty
                ? IconButton(
                    onPressed: () {
                      widget.controller.clear();
                      widget.onSearch('');
                      Provider.of<JobProvider>(context, listen: false)
                          .clearSuggestions();
                    },
                    icon: const Icon(Icons.clear),
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.blue, width: 2),
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
          ),
        ),
        
        // Suggestions
        if (_showSuggestions)
          Consumer<JobProvider>(
            builder: (context, jobProvider, child) {
              if (jobProvider.searchSuggestions.isEmpty) {
                return const SizedBox.shrink();
              }
              
              return Container(
                margin: const EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: jobProvider.searchSuggestions.length,
                  separatorBuilder: (context, index) => Divider(
                    height: 1,
                    color: Colors.grey.shade200,
                  ),
                  itemBuilder: (context, index) {
                    final suggestion = jobProvider.searchSuggestions[index];
                    return ListTile(
                      dense: true,
                      leading: const Icon(
                        Icons.search,
                        size: 18,
                        color: Colors.grey,
                      ),
                      title: Text(
                        suggestion,
                        style: const TextStyle(fontSize: 14),
                      ),
                      onTap: () => _onSuggestionTap(suggestion),
                    );
                  },
                ),
              );
            },
          ),
      ],
    );
  }
}

