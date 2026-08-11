import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/shared/widgets/custom_searchable_dropdown.dart';
import 'package:erp_mobile_cnplus/shared/widgets/custom_form_input.dart';
import 'package:erp_mobile_cnplus/features/master/purchase_team/data/models/purchase_team_models.dart';

class PurchaseTeamFormFields extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final PurchaseTeamFormModel formData;
  final VoidCallback onSubmit;
  final bool isEditMode;
  final PurchaseTeamDropdownData? dropdownData;
  final bool isLoadingDropdown;

  const PurchaseTeamFormFields({
    super.key,
    required this.formKey,
    required this.formData,
    required this.onSubmit,
    required this.isEditMode,
    required this.dropdownData,
    required this.isLoadingDropdown,
  });

  @override
  State<PurchaseTeamFormFields> createState() => _PurchaseTeamFormFieldsState();
}

class _PurchaseTeamFormFieldsState extends State<PurchaseTeamFormFields>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late TextEditingController nameCtrl;
  late TextEditingController descCtrl;

  List<UserDropdown> _selectedMembers = [];
  String _memberSearch = '';

  bool _synced = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    nameCtrl = TextEditingController(text: widget.formData.teamName);
    descCtrl = TextEditingController(text: widget.formData.description);

    if (widget.dropdownData != null) {
      _syncFromDropdown();
    }
  }

  void _syncFromDropdown() {
    _selectedMembers = widget.dropdownData!.users
        .where((u) => widget.formData.memberIds.contains(u.id))
        .toList();
    _synced = true;
  }

  @override
  void didUpdateWidget(PurchaseTeamFormFields oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_synced && widget.dropdownData != null) {
      setState(() => _syncFromDropdown());
    }
  }

  void _saveAllFields() {
    widget.formData.teamName = nameCtrl.text;
    widget.formData.description = descCtrl.text;
    widget.formData.memberIds = _selectedMembers.map((m) => m.id).toList();
  }

  @override
  void dispose() {
    _tabController.dispose();
    nameCtrl.dispose();
    descCtrl.dispose();
    super.dispose();
  }

  UserDropdown? _findUser(int? id) {
    if (id == null || widget.dropdownData == null) return null;
    final matches =
        widget.dropdownData!.users.where((u) => u.id == id);
    return matches.isEmpty ? null : matches.first;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          Container(
            color: colorCard,
            child: TabBar(
              controller: _tabController,
              labelColor: colorPrimary,
              unselectedLabelColor: colorGrey,
              indicatorColor: colorPrimary,
              indicatorWeight: 3,
              tabs: [
                const Tab(text: "Basic Info"),
                Tab(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("Members"),
                      if (_selectedMembers.isNotEmpty) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: colorPrimary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text('${_selectedMembers.length}',
                              style: const TextStyle(
                                  color: colorWhite, fontSize: 11)),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [_buildBasicInfoTab(), _buildMembersTab()],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorCard,
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, -2))
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _saveAllFields();
                  widget.onSubmit();
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: colorPrimary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
                child: Text(
                  widget.isEditMode ? "Update Team" : "Create Team",
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfoTab() {
    final items = widget.dropdownData;

    if (widget.isLoadingDropdown && (items?.users.isEmpty ?? true)) {
      return const Center(
          child: CircularProgressIndicator(color: colorPrimary));
    }

    final selectedLeader = _findUser(widget.formData.teamLeaderId);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomFormInput(
            controller: nameCtrl,
            label: "Team Name",
            required: true,
            hintText: "Enter team name",
            validator: (_) => nameCtrl.text.trim().isEmpty
                ? "Team name is required"
                : null,
          ),
          const SizedBox(height: 16),

          CustomSearchableDropdown<UserDropdown>(
            key: ValueKey(
                'leader_${widget.formData.teamLeaderId}_${items?.users.length ?? 0}'),
            value: selectedLeader,
            items: items?.users ?? [],
            itemLabel: (u) => u.fullName,
            onChanged: (val) {
              setState(() {
                widget.formData.teamLeaderId = val?.id;
                if (val != null) {
                  _selectedMembers.removeWhere((m) => m.id == val.id);
                  widget.formData.memberIds.remove(val.id);
                }
              });
            },
            label: "Team Leader",
            isRequired: true,
            clearable: false,
            validator: (_) => widget.formData.teamLeaderId == null
                ? "Team leader is required"
                : null,
          ),

          const SizedBox(height: 16),
          CustomFormInput(
            controller: descCtrl,
            label: "Description",
            hintText: "Enter team description (optional)",
            maxLines: 3,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildMembersTab() {
    final users = widget.dropdownData?.users ?? [];
    final filteredUsers = users.where((u) {
      final isLeader = widget.formData.teamLeaderId == u.id;
      final matchSearch =
          u.fullName.toLowerCase().contains(_memberSearch.toLowerCase());
      return !isLeader && matchSearch;
    }).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: TextField(
            onChanged: (v) => setState(() => _memberSearch = v),
            decoration: InputDecoration(
              hintText: 'Search member...',
              hintStyle:
                  GoogleFonts.poppins(fontSize: 13, color: colorGrey),
              prefixIcon:
                  const Icon(Icons.search, color: colorGrey, size: 20),
              filled: true,
              fillColor: colorBackground,
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 10),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: colorGreyLight, width: 1)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: colorPrimary, width: 1.5)),
            ),
          ),
        ),
        Expanded(
          child: filteredUsers.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person_search,
                          size: 64, color: colorGreyLight),
                      const SizedBox(height: 12),
                      Text(
                        _memberSearch.isEmpty
                            ? 'No available members'
                            : 'No matching members found',
                        style: GoogleFonts.poppins(
                            color: colorGrey, fontSize: 14),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemCount: filteredUsers.length,
                  itemBuilder: (_, i) {
                    final user = filteredUsers[i];
                    final isSelected =
                        _selectedMembers.any((m) => m.id == user.id);
                    return CheckboxListTile(
                      title: Text(user.fullName,
                          style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w500)),
                      value: isSelected,
                      activeColor: colorPrimary,
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (val) {
                        setState(() {
                          if (val == true) {
                            _selectedMembers.add(user);
                          } else {
                            _selectedMembers
                                .removeWhere((m) => m.id == user.id);
                          }
                        });
                      },
                    );
                  },
                ),
        ),
        if (_selectedMembers.isNotEmpty)
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: colorPrimary.withOpacity(0.08),
              border: Border(
                  top: BorderSide(color: colorPrimary.withOpacity(0.3))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.group, color: colorPrimary, size: 18),
                const SizedBox(width: 8),
                Text('${_selectedMembers.length} member selected',
                    style: GoogleFonts.poppins(
                        color: colorPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 14)),
              ],
            ),
          ),
      ],
    );
  }
}