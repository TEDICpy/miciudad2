$(() => {
  const $form = $('.edit_rendezvous_registrations');

  if ($form.length > 0) {
    const $registrationsEnabled = $form.find('#rendezvous_registrations_enabled');
    const $availableSlots = $form.find('#rendezvous_available_slots');

    const toggleDisabledFields = () => {
      const enabled = $registrationsEnabled.prop('checked');
      $availableSlots.attr('disabled', !enabled);

      $form.find('.editor-container').each((idx, node) => {
        const quill = Quill.find(node);
        quill.enable(enabled);
      })
    };

    $registrationsEnabled.on('change', toggleDisabledFields);
    toggleDisabledFields();
  }
});
