import importlib.util
from pathlib import Path
import subprocess
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location('validate', ROOT / 'migration/validate.py')
validate = importlib.util.module_from_spec(spec)
spec.loader.exec_module(validate)


class OwnershipTests(unittest.TestCase):
  def test_regular_path(self):
    with tempfile.TemporaryDirectory() as directory:
      home = Path(directory)
      self.assertEqual(validate.owned_symlinks(home / '.config/fish/config.fish', home), [])

  def test_broken_nix_link(self):
    with tempfile.TemporaryDirectory() as directory:
      home = Path(directory)
      link = home / 'config.fish'
      link.symlink_to(home / 'missing-nix-store')
      self.assertIn(link, validate.owned_symlinks(link, home))

  def test_parent_owned_by_other_manager(self):
    with tempfile.TemporaryDirectory() as directory:
      home = Path(directory)
      link = home / '.config'
      link.symlink_to(home / 'missing-nix-store')
      self.assertIn(link, validate.owned_symlinks(link / 'fish/config.fish', home))

  def test_git_merge_command_keeps_shell_quoting(self):
    command = subprocess.check_output([
      'git', 'config', '--file', str(ROOT / 'migration/git/config'),
      '--get', 'mergetool.codediff.cmd'
    ], text=True)
    self.assertIn('nvim "$MERGED" -c "CodeDiff merge', command)

  def test_no_committed_identity_guess(self):
    result = subprocess.run([
      'git', 'config', '--file', str(ROOT / 'migration/git/config'),
      '--get', 'user.email'
    ], capture_output=True)
    self.assertEqual(result.returncode, 1)

  def test_wrapper_refuses_unknown_flags(self):
    result = subprocess.run(['bash', str(ROOT / 'migration/bootstrap.sh'), '--force-dotfiles'],
                            capture_output=True)
    self.assertEqual(result.returncode, 2)

  def test_wrapper_refuses_additional_flags(self):
    result = subprocess.run(['bash', str(ROOT / 'migration/bootstrap.sh'), '--apply', '--yes'],
                            capture_output=True)
    self.assertEqual(result.returncode, 2)


if __name__ == '__main__':
  unittest.main()
